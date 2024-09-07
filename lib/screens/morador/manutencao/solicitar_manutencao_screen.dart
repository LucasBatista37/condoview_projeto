import 'package:condoview/components/custom_data_picker.dart';
import 'package:condoview/components/custom_drop_down.dart';
import 'package:condoview/components/custom_image_picker.dart';
import 'package:condoview/components/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:condoview/providers/manutencao_provider.dart';
import 'package:condoview/models/manutencao_model.dart';

class SolicitarManutencaoScreen extends StatefulWidget {
  const SolicitarManutencaoScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SolicitarManutencaoScreenState createState() =>
      _SolicitarManutencaoScreenState();
}

class _SolicitarManutencaoScreenState extends State<SolicitarManutencaoScreen> {
  DateTime? _selectedDate;
  String? _selectedType;
  XFile? _imageFile;

  final TextEditingController _descriptionController = TextEditingController();

  final List<String> _types = [
    'Pintura',
    'Limpeza',
    'Reparo',
    'Inspeção',
    'Outros',
  ];

  void _submit() {
    if (_selectedType == null ||
        _selectedDate == null ||
        _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos!'),
        ),
      );
      return;
    }

    final manutencaoProvider =
        Provider.of<ManutencaoProvider>(context, listen: false);

    final novaManutencao = Manutencao(
      tipo: _selectedType!,
      descricao: _descriptionController.text,
      data: _selectedDate!,
      imagemPath: _imageFile?.path,
    );

    manutencaoProvider.adicionarManutencao(novaManutencao);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Manutenção enviada com sucesso!'),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 78, 20, 166),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Solicitar Manutenção',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Preencha os detalhes para agendar a manutenção.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              CustomDropDown(
                  label: "Selecionar Tipo de Manutenção",
                  items: _types,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedType = newValue;
                    });
                  }),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _descriptionController,
                label: "Descrição da Manutenção",
                maxLines: 5,
              ),
              const SizedBox(height: 16),
              CustomDataPicker(
                onDateSelected: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
                selectedDate: _selectedDate,
              ),
              const SizedBox(height: 16),
              CustomImagePicker(
                onImageSelected: (image) {
                  setState(() {
                    _imageFile = image;
                  });
                },
                selectedImage: _imageFile,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 78, 20, 166),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Solicitar Manutenção',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

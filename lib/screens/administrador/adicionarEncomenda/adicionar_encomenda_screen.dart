import 'package:condoview/components/custom_date_time_picker.dart';
import 'package:condoview/components/custom_drop_down.dart';
import 'package:condoview/components/custom_image_picker.dart';
import 'package:condoview/components/custom_text_field.dart';
import 'package:condoview/models/encomenda_model.dart';
import 'package:condoview/providers/encomenda_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AdicionarEncomendaScreen extends StatefulWidget {
  const AdicionarEncomendaScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdicionarEncomendaScreenState createState() =>
      _AdicionarEncomendaScreenState();
}

class _AdicionarEncomendaScreenState extends State<AdicionarEncomendaScreen> {
  final _titleController = TextEditingController();
  final _apartmentController = TextEditingController();
  DateTime? _selectedDateTime;
  XFile? _imageFile;
  String? _selectedType;
  final List<String> _types = [
    'Pendente',
    'Entregue',
  ];

  void _submit() {
    if (_selectedType == null ||
        _titleController.text.isEmpty ||
        _apartmentController.text.isEmpty ||
        _selectedDateTime == null ||
        _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos.')),
      );
      return;
    }

    final newEncomenda = Encomenda(
      id: DateTime.now().toString(),
      title: _titleController.text,
      apartment: _apartmentController.text,
      time: _selectedDateTime!.toIso8601String(),
      imageFile: _imageFile!.path,
      tipo: _selectedType!,
    );

    Provider.of<EncomendasProvider>(context, listen: false)
        .addEncomenda(newEncomenda);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Encomenda adicionada com sucesso!')),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 78, 20, 166),
        foregroundColor: Colors.white,
        title: const Text('Adicionar Encomenda'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Preencher Dados da Encomenda',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CustomTextField(controller: _titleController, label: "Título"),
            const SizedBox(height: 16),
            CustomTextField(
                controller: _apartmentController, label: "Apartamento"),
            const SizedBox(height: 16),
            CustomDateTimePicker(
              onDateTimeChanged: (dateTime) {
                setState(() {
                  _selectedDateTime = dateTime;
                });
              },
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
            CustomDropDown(
                label: "Status",
                items: _types,
                onChanged: (newValue) {
                  setState(() {
                    _selectedType = newValue;
                  });
                }),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(255, 78, 20, 166),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Adicionar Encomenda',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

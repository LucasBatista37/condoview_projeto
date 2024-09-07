import 'package:condoview/components/custom_data_picker.dart';
import 'package:condoview/components/custom_text_field.dart';
import 'package:condoview/components/custom_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:condoview/providers/assembleia_provider.dart';
import 'package:condoview/models/assembleia_model.dart';

class CriarAssembleiaScreen extends StatefulWidget {
  const CriarAssembleiaScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CriarAssembleiaScreenState createState() => _CriarAssembleiaScreenState();
}

class _CriarAssembleiaScreenState extends State<CriarAssembleiaScreen> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _assuntoController = TextEditingController();
  final TextEditingController _pautaTituloController = TextEditingController();
  final TextEditingController _pautaDescricaoController =
      TextEditingController();
  final List<Pauta> _pautas = [];
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

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
          'Criar Assembleia',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Preencher Dados da Assembleia',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Título',
                controller: _tituloController,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Assunto',
                controller: _assuntoController,
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
              CustomTimePicker(
                  label: 'Horário de Início',
                  onTimeSelected: (time) {
                    setState(() {
                      _selectedTime = time;
                    });
                  },
                  selectedTime: _selectedTime),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _showPautaDialog(),
                child: const Text('Adicionar Pauta'),
              ),
              const SizedBox(height: 16),
              _buildPautasList(),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final assembleia = Assembleia(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      titulo: _tituloController.text,
                      assunto: _assuntoController.text,
                      data: _selectedDate ?? DateTime.now(),
                      horario: _selectedTime ?? TimeOfDay.now(),
                      pautas: _pautas,
                    );

                    Provider.of<AssembleiaProvider>(context, listen: false)
                        .adicionarAssembleia(assembleia);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Assembleia criada com sucesso!'),
                      ),
                    );
                    Navigator.pop(context);
                  },
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
                        'Criar Assembleia',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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

  Widget _buildPautasList() {
    return _pautas.isEmpty
        ? const Text('Nenhuma pauta adicionada.')
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _pautas.map((pauta) {
              return ListTile(
                title: Text(pauta.titulo),
                subtitle: Text(pauta.descricao),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _pautas.remove(pauta);
                    });
                  },
                ),
              );
            }).toList(),
          );
  }

  void _showPautaDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: const Text(
            'Adicionar Pauta',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextField(
                    controller: _tituloController,
                    label: "Título",
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _pautaDescricaoController,
                    label: "Assunto",
                    maxLines: 5,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_pautaTituloController.text.isNotEmpty &&
                          _pautaDescricaoController.text.isNotEmpty) {
                        final pauta = Pauta(
                          titulo: _pautaTituloController.text,
                          descricao: _pautaDescricaoController.text,
                        );
                        Navigator.pop(context);
                        setState(() {
                          _pautas.add(pauta);
                        });
                        _pautaTituloController.clear();
                        _pautaDescricaoController.clear();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Preencha todos os campos.'),
                          ),
                        );
                      }
                    },
                    child: const Text('Adicionar Pauta'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

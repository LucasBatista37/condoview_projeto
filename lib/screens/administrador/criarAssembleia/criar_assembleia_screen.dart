import 'package:condoview/components/custom_button.dart';
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
  final TextEditingController _pautaTemaController = TextEditingController();
  final TextEditingController _pautaDescricaoController =
      TextEditingController();
  final List<Pauta> _pautas = [];
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  void _submit() async {
    if (_tituloController.text.isEmpty ||
        _assuntoController.text.isEmpty ||
        _selectedDate == null ||
        _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos obrigatórios!'),
        ),
      );
      return;
    }

    String formatTimeOfDay(TimeOfDay time) {
      final now = DateTime.now();
      final dateTime =
          DateTime(now.year, now.month, now.day, time.hour, time.minute);
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }

    String determinarStatus(DateTime data, TimeOfDay horario) {
      DateTime agora = DateTime.now();
      DateTime dataHoraAssembleia = DateTime(
          data.year, data.month, data.day, horario.hour, horario.minute);

      if (dataHoraAssembleia.isAfter(agora)) {
        return 'pendente'; // A assembleia está no futuro
      } else if (dataHoraAssembleia.isBefore(agora)) {
        return 'encerrada'; // A assembleia está no passado
      } else {
        return 'em andamento'; // A assembleia está acontecendo agora
      }
    }

// Criação da instância de Assembleia
    final assembleia = Assembleia(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      titulo: _tituloController.text,
      assunto: _assuntoController.text,
      data:
          _selectedDate!, // Certifique-se de que _selectedDate é um DateTime válido
      horario: _selectedTime!, // Passar o objeto TimeOfDay diretamente
      status: determinarStatus(
          _selectedDate!, _selectedTime!), // Adiciona o status aqui
      pautas: _pautas,
    );

    try {
      await Provider.of<AssembleiaProvider>(context, listen: false)
          .adicionarAssembleia(assembleia);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Assembleia criada com sucesso!'),
        ),
      );
      Navigator.pop(context);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao criar a assembleia.'),
        ),
      );
    }
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
              CustomButton(
                  label: "Criar Assembleia",
                  icon: Icons.add,
                  onPressed: _submit)
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
                title: Text(pauta.tema),
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
                    controller: _pautaTemaController,
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
                      if (_pautaTemaController.text.isNotEmpty &&
                          _pautaDescricaoController.text.isNotEmpty) {
                        final pauta = Pauta(
                          tema: _pautaTemaController.text,
                          descricao: _pautaDescricaoController.text,
                        );
                        Navigator.pop(context);
                        setState(() {
                          _pautas.add(pauta);
                        });
                        _pautaTemaController.clear();
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

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Preencher Dados da Assembleia',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Título',
                controller: _tituloController,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Assunto',
                controller: _assuntoController,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              _buildDatePicker(context),
              const SizedBox(height: 16),
              _buildTimePicker(context),
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null && picked != _selectedDate) {
          setState(() {
            _selectedDate = picked;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedDate == null
                  ? 'Selecionar Data'
                  : 'Data: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
            ),
            const Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: _selectedTime ?? TimeOfDay.now(),
        );
        if (picked != null && picked != _selectedTime) {
          setState(() {
            _selectedTime = picked;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedTime == null
                  ? 'Selecionar Horário'
                  : 'Horário: ${_selectedTime!.format(context)}',
            ),
            const Icon(Icons.access_time),
          ],
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Adicionar Pauta',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _pautaTituloController,
                decoration: const InputDecoration(
                  labelText: 'Título da Pauta',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _pautaDescricaoController,
                decoration: const InputDecoration(
                  labelText: 'Descrição da Pauta',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
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
                  }
                },
                child: const Text('Adicionar Pauta'),
              ),
            ],
          ),
        );
      },
    );
  }
}

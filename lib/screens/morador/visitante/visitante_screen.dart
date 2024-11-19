import 'package:condoview/components/gerar_convite.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:condoview/providers/usuario_provider.dart';

class VisitanteScreen extends StatefulWidget {
  const VisitanteScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _VisitanteScreenState createState() => _VisitanteScreenState();
}

class _VisitanteScreenState extends State<VisitanteScreen> {
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _horaController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _unidadeController = TextEditingController();
  final String condominioFicticio = "Condomínio Atlas";
  final String enderecoFicticio = "Rua da Praia, 123 - Centro";

  @override
  void dispose() {
    _dataController.dispose();
    _horaController.dispose();
    _nomeController.dispose();
    _unidadeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      setState(() {
        _dataController.text =
            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        _horaController.text = selectedTime.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String anfitriao = Provider.of<UsuarioProvider>(context).userName;

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
          'Visitante',
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
                'Insira os dados e compartilhe este convite\ncom o visitante para que ele possa ter a\nentrada liberada',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dados do convite',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _dataController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today),
                        labelText: 'Data',
                        suffixIcon: Icon(Icons.arrow_drop_down),
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _horaController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.access_time),
                        labelText: 'Hora',
                        suffixIcon: Icon(Icons.arrow_drop_down),
                      ),
                      readOnly: true,
                      onTap: () => _selectTime(context),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _nomeController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        labelText: 'Nome do Visitante',
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _unidadeController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.home),
                        labelText: 'Unidade',
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GerarConvite(
                data: _dataController.text,
                hora: _horaController.text,
                nome: _nomeController.text,
                unidade: _unidadeController.text,
                condominio: condominioFicticio,
                endereco: enderecoFicticio,
                anfitriao: anfitriao,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

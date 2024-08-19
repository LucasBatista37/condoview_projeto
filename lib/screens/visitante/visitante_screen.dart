import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

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

  @override
  void dispose() {
    _dataController.dispose();
    _horaController.dispose();
    _nomeController.dispose();
    _unidadeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null && selectedDate != DateTime.now()) {
      setState(() {
        _dataController.text =
            '${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.year}';
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        _horaController.text = selectedTime.format(context);
      });
    }
  }

  void _compartilharConvite() {
    final String convite = '''
      Dados do convite:
      Data: ${_dataController.text}
      Hora: ${_horaController.text}
      Nome: ${_nomeController.text}
      Unidade: ${_unidadeController.text}
    ''';

    Share.share(convite);
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
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _unidadeController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.home),
                        labelText: 'Unidade Habitacional',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _compartilharConvite,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor:
                      const Color.fromARGB(255, 78, 20, 166), // Cor do texto
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12), // Borda arredondada
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 16), // Padding interno
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.share, size: 24), // Ícone de compartilhar
                    SizedBox(width: 8), // Espaço entre o ícone e o texto
                    Text(
                      'Compartilhar convite',
                      style: TextStyle(fontSize: 16), // Tamanho da fonte
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}

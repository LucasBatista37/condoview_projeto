import 'package:condoview/components/custom_data_picker.dart';
import 'package:condoview/components/custom_drop_down.dart';
import 'package:condoview/components/custom_text_field.dart';
import 'package:condoview/components/custom_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:condoview/providers/reserva_provider.dart';
import 'package:condoview/models/reserva_model.dart';

class SolicitarReserva extends StatefulWidget {
  const SolicitarReserva({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SolicitarReservaState createState() => _SolicitarReservaState();
}

class _SolicitarReservaState extends State<SolicitarReserva> {
  final TextEditingController _descricaoController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  final List<String> _areasFixas = [
    'Salão de Festas',
    'Churrasqueira',
    'Quadra de Esportes',
    'Piscina',
  ];

  String? _selectedArea;

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
          'Solicitar reserva',
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
                'Preencher Dados da Reserva',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              CustomDropDown(
                  label: 'Escolher Área',
                  value: _selectedArea,
                  items: _areasFixas,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedArea = newValue;
                    });
                  }),
              const SizedBox(height: 16),
              CustomTextField(
                  label: 'Descrição',
                  controller: _descricaoController,
                  maxLines: 5),
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
                      _startTime = time;
                    });
                  },
                  selectedTime: _startTime),
              const SizedBox(height: 16),
              CustomTimePicker(
                  label: 'Horário de Término',
                  onTimeSelected: (time) {
                    setState(() {
                      _endTime = time;
                    });
                  },
                  selectedTime: _endTime),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final reserva = Reserva(
                      area: _selectedArea ?? 'Não especificado',
                      descricao: _descricaoController.text,
                      data: _selectedDate ?? DateTime.now(),
                      horarioInicio: _startTime ?? TimeOfDay.now(),
                      horarioFim: _endTime ?? TimeOfDay.now(),
                    );

                    Provider.of<ReservaProvider>(context, listen: false)
                        .adicionarReserva(reserva);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Reserva enviada com sucesso!'),
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
                        'Solicitar Reserva',
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

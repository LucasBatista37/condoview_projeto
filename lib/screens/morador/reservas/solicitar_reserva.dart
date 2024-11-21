import 'package:condoview/components/custom_button.dart';
import 'package:condoview/components/custom_data_picker.dart';
import 'package:condoview/components/custom_drop_down.dart';
import 'package:condoview/components/custom_text_field.dart';
import 'package:condoview/components/custom_time_picker.dart';
import 'package:condoview/providers/usuario_provider.dart';
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

  void _submit() async {
    debugPrint('Iniciando submissão da reserva.');

    print('Horário de Início: $_startTime');
    print('Horário de Término: $_endTime');

    if (_selectedArea == null ||
        _selectedDate == null ||
        _startTime == null ||
        _endTime == null ||
        _descricaoController.text.isEmpty) {
      debugPrint('Erro: Alguns campos obrigatórios não foram preenchidos.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos!'),
        ),
      );
      return;
    }

    if (_descricaoController.text.length < 5) {
      debugPrint('Erro: A descrição tem menos de 5 caracteres.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A descrição deve ter pelo menos 5 caracteres.'),
        ),
      );
      return;
    }

    final usuarioProvider =
        Provider.of<UsuarioProvider>(context, listen: false);
    final userName = usuarioProvider.userName;
    debugPrint('Nome do usuário obtido: $userName');

    final novaReserva = Reserva(
      area: _selectedArea!,
      descricao: _descricaoController.text,
      data: _selectedDate!,
      horarioInicio: _startTime!,
      horarioFim: _endTime!,
      nomeUsuario: userName, 
    );

    debugPrint('Nova reserva criada: ${novaReserva.toJson()}');

    final reservaProvider =
        Provider.of<ReservaProvider>(context, listen: false);

    try {
      debugPrint('Enviando reserva ao provider...');
      await reservaProvider.adicionarReserva(context, novaReserva);
      debugPrint('Reserva enviada com sucesso.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reserva adicionada com sucesso!')),
      );
      Navigator.pop(context);
    } catch (error) {
      debugPrint('Erro ao adicionar reserva: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao adicionar reserva.')),
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
              CustomButton(
                  label: 'Solicitar Reserva',
                  icon: Icons.add,
                  onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}

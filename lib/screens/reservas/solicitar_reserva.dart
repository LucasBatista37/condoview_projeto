import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ReservaScreen extends StatefulWidget {
  const ReservaScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ReservaScreenState createState() => _ReservaScreenState();
}

class _ReservaScreenState extends State<ReservaScreen> {
  final TextEditingController _motivoController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  XFile? _image;

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
              _buildTextField(
                  label: 'Motivo da Reserva', controller: _motivoController),
              const SizedBox(height: 16),
              _buildTextField(
                  label: 'Descrição',
                  controller: _descricaoController,
                  maxLines: 5),
              const SizedBox(height: 16),
              _buildDatePicker(context),
              const SizedBox(height: 16),
              _buildTimePicker(context, label: 'Horário de Início',
                  onTimeSelected: (time) {
                setState(() {
                  _startTime = time;
                });
              }, selectedTime: _startTime),
              const SizedBox(height: 16),
              _buildTimePicker(context, label: 'Horário de Fim',
                  onTimeSelected: (time) {
                setState(() {
                  _endTime = time;
                });
              }, selectedTime: _endTime),
              const SizedBox(height: 16),
              _buildImagePicker(context),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Lógica para enviar a reserva
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Reserva enviada com sucesso!'),
                      ),
                    );
                    Navigator.pop(context); // Fechar a tela de reservas
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

  Widget _buildTextField(
      {required String label,
      required TextEditingController controller,
      int maxLines = 1}) {
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
                  : 'Data: ${_selectedDate!.month}/${_selectedDate!.day}/${_selectedDate!.year}',
            ),
            const Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker(BuildContext context,
      {required String label,
      required Function(TimeOfDay) onTimeSelected,
      TimeOfDay? selectedTime}) {
    return GestureDetector(
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: selectedTime ?? TimeOfDay.now(),
        );
        if (picked != null && picked != selectedTime) {
          onTimeSelected(picked);
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
              selectedTime == null
                  ? label
                  : '$label: ${selectedTime.format(context)}',
            ),
            const Icon(Icons.access_time),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final ImagePicker picker = ImagePicker();
            final XFile? pickedImage =
                await picker.pickImage(source: ImageSource.gallery);

            setState(() {
              _image = pickedImage;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_image == null
                    ? 'Selecionar Imagem'
                    : 'Imagem Selecionada'),
                const Icon(Icons.photo),
              ],
            ),
          ),
        ),
        if (_image != null) ...[
          const SizedBox(height: 16),
          Center(
            child: Image.file(
              File(_image!.path),
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        ]
      ],
    );
  }
}

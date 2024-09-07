import 'package:condoview/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/assembleia_model.dart';
import '../../../providers/assembleia_provider.dart';
import 'package:intl/intl.dart';

class EditarAssembleiaScreen extends StatefulWidget {
  final Assembleia assembleia;

  const EditarAssembleiaScreen({super.key, required this.assembleia});

  @override
  // ignore: library_private_types_in_public_api
  _EditarAssembleiaScreenState createState() => _EditarAssembleiaScreenState();
}

class _EditarAssembleiaScreenState extends State<EditarAssembleiaScreen> {
  final _tituloController = TextEditingController();
  final _assuntoController = TextEditingController();
  String _status = 'Pendente';
  late DateTime _data;
  late TimeOfDay _horario;

  @override
  void initState() {
    super.initState();
    _tituloController.text = widget.assembleia.titulo;
    _assuntoController.text = widget.assembleia.assunto;
    _status = widget.assembleia.status;
    _data = widget.assembleia.data;
    _horario = widget.assembleia.horario;
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _data,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _data) {
      setState(() {
        _data = pickedDate;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _horario,
    );
    if (pickedTime != null && pickedTime != _horario) {
      setState(() {
        _horario = pickedTime;
      });
    }
  }

  void _submit() {
    final updatedAssembleia = Assembleia(
      id: widget.assembleia.id,
      titulo: _tituloController.text,
      assunto: _assuntoController.text,
      status: _status,
      data: _data,
      horario: _horario,
      pautas: widget.assembleia.pautas,
    );
    Provider.of<AssembleiaProvider>(context, listen: false)
        .updateAssembleia(updatedAssembleia);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 78, 20, 166),
        foregroundColor: Colors.white,
        title: const Text(
          'Editar Assembleia',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTextField(
              controller: _tituloController,
              labelText: 'Título',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _assuntoController,
              labelText: 'Assunto',
            ),
            const SizedBox(height: 16),
            _buildDropdownButton(),
            const SizedBox(height: 16),
            _buildDateSelector(),
            const SizedBox(height: 16),
            _buildTimeSelector(),
            const SizedBox(height: 16),
            CustomButton(
                label: "Salvar Alterações",
                icon: Icons.save,
                onPressed: _submit)
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
      keyboardType: TextInputType.text,
    );
  }

  Widget _buildDropdownButton() {
    return DropdownButtonFormField<String>(
      value: _status,
      items: const [
        DropdownMenuItem(value: 'Pendente', child: Text('Pendente')),
        DropdownMenuItem(value: 'Em andamento', child: Text('Em andamento')),
        DropdownMenuItem(value: 'Concluída', child: Text('Concluída')),
      ],
      onChanged: (value) {
        setState(() {
          _status = value!;
        });
      },
      decoration: InputDecoration(
        labelText: 'Status',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
    );
  }

  Widget _buildDateSelector() {
    return GestureDetector(
      onTap: _selectDate,
      child: AbsorbPointer(
        child: TextField(
          controller: TextEditingController(
              text: DateFormat('dd/MM/yyyy').format(_data)),
          decoration: InputDecoration(
            labelText: 'Data',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            suffixIcon: const Icon(Icons.calendar_today),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSelector() {
    return GestureDetector(
      onTap: _selectTime,
      child: AbsorbPointer(
        child: TextField(
          controller: TextEditingController(text: _horario.format(context)),
          decoration: InputDecoration(
            labelText: 'Horário',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            suffixIcon: const Icon(Icons.access_time),
          ),
        ),
      ),
    );
  }
}

import 'package:condoview/components/custom_button.dart';
import 'package:condoview/models/usuario_model.dart';
import 'package:flutter/material.dart';

class EditarMoradorScreen extends StatefulWidget {
  final Usuario morador;

  const EditarMoradorScreen({super.key, required this.morador});

  @override
  _EditarMoradorScreenState createState() => _EditarMoradorScreenState();
}

class _EditarMoradorScreenState extends State<EditarMoradorScreen> {
  final _nomeController = TextEditingController();
  final _apartamentoController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nomeController.text = widget.morador.nome;
    _apartamentoController.text = widget.morador.apartamento!;
    _emailController.text = widget.morador.email;
    _telefoneController.text = widget.morador.telefone!;
  }

  void _submit() {
    final updatedMorador = Usuario(
      id: 'id_padrão',
      nome: _nomeController.text,
      email: _emailController.text,
      senha: 'senha_padrão',
      apartamento: _apartamentoController.text,
      telefone: _telefoneController.text,
    );
    Navigator.pop(context, updatedMorador);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 78, 20, 166),
        foregroundColor: Colors.white,
        title: const Text('Editar Morador'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTextField(
              controller: _nomeController,
              labelText: 'Nome',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _apartamentoController,
              labelText: 'Apartamento',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _emailController,
              labelText: 'Email',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _telefoneController,
              labelText: 'Telefone',
            ),
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
    );
  }
}

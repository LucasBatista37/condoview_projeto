import 'package:flutter/material.dart';
import 'lista_moradores_screen.dart';

class EditarMoradorScreen extends StatefulWidget {
  final Morador morador;

  const EditarMoradorScreen({super.key, required this.morador});

  @override
  // ignore: library_private_types_in_public_api
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
    _apartamentoController.text = widget.morador.apartamento;
    _emailController.text = widget.morador.email;
    _telefoneController.text = widget.morador.telefone;
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
            ElevatedButton(
              onPressed: () {
                final updatedMorador = Morador(
                  nome: _nomeController.text,
                  apartamento: _apartamentoController.text,
                  email: _emailController.text,
                  telefone: _telefoneController.text,
                );
                Navigator.pop(context, updatedMorador);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(255, 78, 20, 166),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: const Text('Salvar Alterações'),
            ),
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

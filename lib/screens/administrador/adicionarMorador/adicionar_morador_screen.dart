import 'package:flutter/material.dart';

class AdicionarMoradorScreen extends StatefulWidget {
  const AdicionarMoradorScreen({super.key});

  @override
  _AdicionarMoradorScreenState createState() => _AdicionarMoradorScreenState();
}

class _AdicionarMoradorScreenState extends State<AdicionarMoradorScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  String? _funcionalidadeSelecionada;

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
          'Adicionar Morador',
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
            children: [
              const SizedBox(height: 32),
              _buildTextField(label: 'E-mail', controller: _emailController),
              const SizedBox(height: 16),
              _buildTextField(
                  label: 'Telefone', controller: _telefoneController),
              const SizedBox(height: 16),
              _buildFuncionalidadeDropdown(),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Morador adicionado com sucesso!'),
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
                      Icon(Icons.person_add, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Adicionar Morador',
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

  Widget _buildFuncionalidadeDropdown() {
    return DropdownButtonFormField<String>(
      value: _funcionalidadeSelecionada,
      hint: const Text('Selecionar Funcionalidade'),
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
      items: ['Síndico', 'Morador'].map((funcionalidade) {
        return DropdownMenuItem<String>(
          value: funcionalidade,
          child: Text(funcionalidade),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _funcionalidadeSelecionada = value;
        });
      },
    );
  }
}

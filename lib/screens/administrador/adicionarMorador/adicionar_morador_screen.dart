import 'package:condoview/components/custom_drop_down.dart';
import 'package:condoview/components/custom_text_field.dart';
import 'package:flutter/material.dart';

class AdicionarMoradorScreen extends StatefulWidget {
  const AdicionarMoradorScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdicionarMoradorScreenState createState() => _AdicionarMoradorScreenState();
}

class _AdicionarMoradorScreenState extends State<AdicionarMoradorScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final List<String> _funcionalidadeAdicionada = [
    'Morador',
    'Síndico',
  ];

  String? _selectedFuncionalidade;

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
              CustomTextField(label: 'E-mail', controller: _emailController),
              const SizedBox(height: 16),
              CustomTextField(
                  label: 'Telefone', controller: _telefoneController),
              const SizedBox(height: 16),
              CustomDropDown(
                  label: 'Adicionar Funcionalidade',
                  value: _selectedFuncionalidade,
                  items: _funcionalidadeAdicionada,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedFuncionalidade = newValue;
                    });
                  }),
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
}

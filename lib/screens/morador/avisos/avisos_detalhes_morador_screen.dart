import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:condoview/providers/aviso_provider.dart';
import 'package:condoview/models/aviso_model.dart';

class AvisosDetalhesMoradorScreen extends StatelessWidget {
  final String id;

  const AvisosDetalhesMoradorScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final avisoProvider = Provider.of<AvisoProvider>(context);
    final Aviso? aviso = avisoProvider.getAvisoById(id);

    if (aviso == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 78, 20, 166),
          foregroundColor: Colors.white,
          title: const Text('Detalhes do Aviso'),
        ),
        body: const Center(
          child: Text('Aviso não encontrado.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 78, 20, 166),
        foregroundColor: Colors.white,
        title: const Text(
          'Detalhes do Aviso',
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
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  aviso.icon,
                  size: 40,
                  color: const Color.fromARGB(255, 78, 20, 166),
                ),
                const SizedBox(height: 16),
                Text(
                  aviso.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  aviso.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                Text(
                  'Data: ${aviso.time}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

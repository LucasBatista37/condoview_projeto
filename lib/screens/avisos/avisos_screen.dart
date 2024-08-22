import 'package:condoview/providers/aviso_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AvisosScreen extends StatelessWidget {
  const AvisosScreen({super.key});

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
          'Avisos',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<AvisoProvider>(
          builder: (context, avisoProvider, child) {
            return ListView.builder(
              itemCount: avisoProvider.avisos.length,
              itemBuilder: (context, index) {
                final aviso = avisoProvider.avisos[index];
                return _buildAvisoItem(
                  aviso.icon,
                  aviso.title,
                  aviso.description,
                  aviso.time,
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildAvisoItem(
      IconData icon, String title, String description, String time) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: Icon(icon, color: const Color.fromARGB(255, 78, 20, 166)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            const SizedBox(height: 4),
            Text(
              time,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

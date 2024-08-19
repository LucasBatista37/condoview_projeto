import 'package:flutter/material.dart';

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
        child: ListView(
          children: [
            _buildAvisoItem(
              Icons.info, // Ícone à esquerda
              'Manutenção Programada',
              'Prezados residentes, informamos que haverá uma manutenção programada no sistema de água do condomínio no dia 15 de julho, das 09h às 17h.',
              'Enviado dia 10 de julho às 10:30',
            ),
            _buildAvisoItem(
              Icons.event, // Ícone à esquerda
              'Festa de Confraternização',
              'Caros condôminos, estamos organizando a nossa festa de confraternização que ocorrerá no dia 20 de julho, a partir das 19h, na área de lazer.',
              'Enviado dia 10 de julho às 10:30',
            ),
            _buildAvisoItem(
              Icons.help, // Ícone à esquerda
              'Ajuda com Mudança',
              'No sábado, 5 de julho, dois moradores estarão se mudando do bloco C e precisarão de ajuda para carregar algumas caixas.',
              'Enviado dia 10 de julho às 10:30',
            ),
          ],
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

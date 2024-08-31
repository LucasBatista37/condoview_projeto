import 'dart:io';
import 'package:condoview/models/encomenda_model.dart';
import 'package:flutter/material.dart';

class EncomendaDetalhesScreen extends StatelessWidget {
  final Encomenda encomenda;

  EncomendaDetalhesScreen({required this.encomenda});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 78, 20, 166),
        foregroundColor: Colors.white,
        title: const Text('Detalhes da Encomenda'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: encomenda.imageUrl.startsWith('http')
                  ? Image.network(
                      encomenda.imageUrl,
                      height: 200,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      File(encomenda.imageUrl),
                      height: 200,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(height: 16),
            Text(
              encomenda.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Apartamento: ${encomenda.apartment}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Data/Hora: ${encomenda.time}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Status: ${encomenda.status}',
              style: TextStyle(
                fontSize: 18,
                color: encomenda.status == 'Entregue'
                    ? Colors.green
                    : Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:condoview/models/encomenda_model.dart';
import 'package:condoview/providers/encomenda_provider.dart';
import 'package:condoview/screens/morador/encomendas/encomendas_detalhes_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EncomendasScreen extends StatelessWidget {
  const EncomendasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 78, 20, 166),
        foregroundColor: Colors.white,
        title: const Text('Encomendas'),
        centerTitle: true,
      ),
      body: Consumer<EncomendasProvider>(
        builder: (context, encomendasProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: encomendasProvider.encomendas.length,
              itemBuilder: (context, index) {
                final encomenda = encomendasProvider.encomendas[index];
                return _buildEncomendaItem(context, encomenda);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEncomendaItem(BuildContext context, Encomenda encomenda) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: encomenda.imageUrl.startsWith('http')
              ? Image.network(
                  encomenda.imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
              : Image.file(
                  File(encomenda.imageUrl),
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
        ),
        title: Text(encomenda.title),
        subtitle: Text('${encomenda.apartment}\n${encomenda.time}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.arrow_forward),
            const SizedBox(height: 4),
            Text(
              encomenda.status,
              style: TextStyle(
                color: encomenda.status == 'Entregue'
                    ? Colors.green
                    : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        isThreeLine: true,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  EncomendaDetalhesScreen(encomenda: encomenda),
            ),
          );
        },
      ),
    );
  }
}

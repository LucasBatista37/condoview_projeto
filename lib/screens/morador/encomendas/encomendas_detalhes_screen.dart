import 'dart:io';
import 'package:condoview/models/encomenda_model.dart';
import 'package:condoview/providers/encomenda_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EncomendaDetalhesScreen extends StatelessWidget {
  final Encomenda encomenda;

  const EncomendaDetalhesScreen({super.key, required this.encomenda});

  Future<void> _alterarStatus(BuildContext context) async {
    final provider = Provider.of<EncomendasProvider>(context, listen: false);
    final novoStatus = encomenda.status == 'Pendente' ? 'Entregue' : 'Pendente';

    if (encomenda.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro: ID da encomenda é nulo!')),
      );
      return;
    }

    final encomendaAtualizada = Encomenda(
      id: encomenda.id!,
      title: encomenda.title,
      apartment: encomenda.apartment,
      time: encomenda.time,
      imagePath: encomenda.imagePath,
      status: novoStatus,
    );

    try {
      await provider.updateEncomenda(encomendaAtualizada);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status atualizado para $novoStatus!')),
      );
      // Voltar para a tela anterior
      Navigator.pop(context);
    } catch (error) {
      print('Erro ao atualizar status: $error'); // Para rastreamento de erros
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar status: $error')),
      );
    }
  }

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
              child: Image.file(
                File(encomenda.imagePath),
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _alterarStatus(context),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(255, 78, 20, 166),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    encomenda.status == 'Entregue' ? Icons.undo : Icons.check,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    encomenda.status == 'Entregue'
                        ? 'Marcar como Pendente'
                        : 'Marcar como Entregue',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

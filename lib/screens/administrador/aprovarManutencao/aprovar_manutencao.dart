import 'dart:io';

import 'package:condoview/providers/manutencao_provider.dart';
import 'package:flutter/material.dart';
import 'package:condoview/models/manutencao_model.dart';
import 'package:provider/provider.dart';

class AprovarManutencaoScreen extends StatelessWidget {
  final Manutencao manutencao;
  final int manutencaoIndex;

  const AprovarManutencaoScreen({
    super.key,
    required this.manutencao,
    required this.manutencaoIndex,
  });

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
          'Aprovar Manutenção',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailContainer(
                label: 'Tipo de Manutenção', value: manutencao.tipo),
            const SizedBox(height: 16),
            _buildDetailContainer(
                label: 'Descrição', value: manutencao.descricao),
            const SizedBox(height: 16),
            _buildDetailContainer(
              label: 'Data',
              value:
                  '${manutencao.data.day}/${manutencao.data.month}/${manutencao.data.year}',
            ),
            const SizedBox(height: 16),
            if (manutencao.imagemPath != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Imagem Anexada:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Image.file(
                    File(manutencao.imagemPath!),
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final provider = Provider.of<ManutencaoProvider>(context,
                          listen: false);
                      provider.aprovarManutencao(manutencaoIndex);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Manutenção aprovada com sucesso!'),
                        ),
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: const Text(
                      'Aprovar Manutenção',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final provider = Provider.of<ManutencaoProvider>(context,
                          listen: false);
                      provider.rejeitarManutencao(manutencaoIndex);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Manutenção rejeitada.'),
                        ),
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: const Text(
                      'Rejeitar Manutenção',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailContainer({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 2.0),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
        const Divider(
          color: Colors.grey,
          thickness: 1,
        ),
      ],
    );
  }
}

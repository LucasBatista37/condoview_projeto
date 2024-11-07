import 'package:condoview/providers/ocorrencia_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VisualizarOcorrenciaScreen extends StatelessWidget {
  const VisualizarOcorrenciaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ocorrenciaProvider = Provider.of<OcorrenciaProvider>(context);
    final ocorrencia = ocorrenciaProvider.selectedOcorrencia;

    if (ocorrencia == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 78, 20, 166),
          foregroundColor: Colors.white,
          title: const Text('Ocorrência'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('Nenhuma ocorrência selecionada.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 78, 20, 166),
        foregroundColor: Colors.white,
        title: const Text('Visualizar Ocorrência'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailContainer(label: 'Motivo', value: ocorrencia.motivo),
            const SizedBox(height: 16),
            _buildDetailContainer(
                label: 'Descrição', value: ocorrencia.descricao),
            const SizedBox(height: 16),
            _buildDetailContainer(
              label: 'Data',
              value:
                  '${ocorrencia.data.day}/${ocorrencia.data.month}/${ocorrencia.data.year}',
            ),
            if (ocorrencia.imagemPath != null &&
                ocorrencia.imagemPath!.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Imagem Anexada:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Builder(builder: (context) {
                final imageUrl = 'https://backend-condoview.onrender.com/' +
                    ocorrencia.imagemPath!.replaceAll(r'\', '/');
                debugPrint('Caminho da imagem: $imageUrl');

                return Image.network(
                  imageUrl,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    debugPrint('Erro ao carregar a imagem: $error');
                    return const Text(
                      'Erro ao carregar a imagem',
                      style: TextStyle(color: Colors.red),
                    );
                  },
                );
              }),
            ],
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

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
    debugPrint('ID da manutenção: ${manutencao.id}');
    debugPrint('Tipo de manutenção: ${manutencao.tipo}');
    debugPrint('Descrição: ${manutencao.descricao}');
    debugPrint('Data: ${manutencao.data}');
    debugPrint('Imagem Path: ${manutencao.imagemPath}');

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
              label: 'Tipo de Manutenção',
              value: manutencao.tipo,
            ),
            const SizedBox(height: 16),
            _buildDetailContainer(
              label: 'Descrição',
              value: manutencao.descricao,
            ),
            const SizedBox(height: 16),
            _buildDetailContainer(
              label: 'Data',
              value:
                  '${manutencao.data.day}/${manutencao.data.month}/${manutencao.data.year}',
            ),
            _buildDetailContainer(
              label: 'Nome do Usuário',
              value: manutencao.usuarioNome,
            ),
            const SizedBox(height: 16),
            _buildImageSection(),
            const SizedBox(height: 16),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    if (manutencao.imagemPath != null && manutencao.imagemPath!.isNotEmpty) {
      final imageUrl = 'https://backend-condoview.onrender.com/' +
          manutencao.imagemPath!.replaceAll(r'\', '/');
      debugPrint('URL da imagem gerada: $imageUrl');

      return Column(
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
          Image.network(
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
          ),
        ],
      );
    } else {
      return const Text(
        'Nenhuma imagem anexada.',
        style: TextStyle(color: Colors.grey),
      );
    }
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              final provider =
                  Provider.of<ManutencaoProvider>(context, listen: false);
              if (manutencao.id != null) {
                debugPrint('Aprovando manutenção com ID: ${manutencao.id}');
                provider.aprovarManutencao(manutencao.id!);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Manutenção aprovada com sucesso!'),
                  ),
                );
                Navigator.pop(context);
              } else {
                debugPrint('Erro: ID da manutenção é nulo.');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Erro: ID da manutenção é nulo.'),
                  ),
                );
              }
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
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              final provider =
                  Provider.of<ManutencaoProvider>(context, listen: false);
              if (manutencao.id != null) {
                debugPrint('Rejeitando manutenção com ID: ${manutencao.id}');
                provider.rejeitarManutencao(manutencao.id!);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Manutenção rejeitada.'),
                  ),
                );
                Navigator.pop(context);
              } else {
                debugPrint('Erro: ID da manutenção é nulo.');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Erro: ID da manutenção é nulo.'),
                  ),
                );
              }
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
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
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

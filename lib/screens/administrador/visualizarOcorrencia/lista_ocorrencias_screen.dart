import 'package:condoview/components/custom_empty.dart';
import 'package:condoview/providers/ocorrencia_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'visualizar_ocorrencia_screen.dart';

class ListaOcorrenciasScreen extends StatelessWidget {
  const ListaOcorrenciasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ocorrenciaProvider = Provider.of<OcorrenciaProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 78, 20, 166),
        foregroundColor: Colors.white,
        title: const Text(
          'Ocorrências',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lista de Ocorrências',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ocorrenciaProvider.ocorrencias.isEmpty
                  ? const CustomEmpty(text: "Nenhuma ocorrência pendente.")
                  : ListView.builder(
                      itemCount: ocorrenciaProvider.ocorrencias.length,
                      itemBuilder: (context, index) {
                        final ocorrencia =
                            ocorrenciaProvider.ocorrencias[index];
                        return _buildOcorrenciaCard(
                          context,
                          title: ocorrencia.motivo,
                          date:
                              '${ocorrencia.data.day}/${ocorrencia.data.month}/${ocorrencia.data.year}',
                          description: ocorrencia.descricao,
                          onTap: () {
                            ocorrenciaProvider.selectOcorrencia(ocorrencia);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const VisualizarOcorrenciaScreen(),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOcorrenciaCard(BuildContext context,
      {required String title,
      required String date,
      required String description,
      required VoidCallback onTap}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      child: ListTile(
        leading:
            const Icon(Icons.warning, color: Color.fromARGB(255, 78, 20, 166)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: Text(
          date,
          style: const TextStyle(color: Colors.grey),
        ),
        onTap: onTap,
      ),
    );
  }
}

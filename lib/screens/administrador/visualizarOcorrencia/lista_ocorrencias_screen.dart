import 'package:condoview/components/custom_empty.dart';
import 'package:condoview/providers/ocorrencia_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'visualizar_ocorrencia_screen.dart';

class ListaOcorrenciasScreen extends StatefulWidget {
  const ListaOcorrenciasScreen({super.key});

  @override
  _ListaOcorrenciasScreenState createState() => _ListaOcorrenciasScreenState();
}

class _ListaOcorrenciasScreenState extends State<ListaOcorrenciasScreen> {
  bool _isInitialLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOcorrencias();
  }

  Future<void> _fetchOcorrencias() async {
    try {
      final ocorrenciaProvider =
          Provider.of<OcorrenciaProvider>(context, listen: false);
      await ocorrenciaProvider.fetchOcorrencias();
      ocorrenciaProvider.startPolling();
    } catch (error) {
      print("Erro ao buscar ocorrências: $error");
    } finally {
      setState(() {
        _isInitialLoading = false; 
      });
    }
  }

  @override
  void dispose() {
    final ocorrenciaProvider =
        Provider.of<OcorrenciaProvider>(context, listen: false);
    ocorrenciaProvider.stopPolling(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ocorrenciaProvider = Provider.of<OcorrenciaProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 78, 20, 166),
        foregroundColor: Colors.white,
        title: const Text('Ocorrências'),
        centerTitle: true,
      ),
      body: _isInitialLoading
          ? const Center(child: CircularProgressIndicator())
          : ocorrenciaProvider.ocorrencias.isEmpty
              ? const CustomEmpty(text: 'Nenhuma ocorrência pendente.')
              : _buildOcorrenciaList(context, ocorrenciaProvider),
    );
  }

  Widget _buildOcorrenciaList(
      BuildContext context, OcorrenciaProvider ocorrenciaProvider) {
    return ListView.builder(
      itemCount: ocorrenciaProvider.ocorrencias.length,
      itemBuilder: (context, index) {
        final ocorrencia = ocorrenciaProvider.ocorrencias[index];
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
                builder: (context) => const VisualizarOcorrenciaScreen(),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildOcorrenciaCard(BuildContext context,
      {required String title,
      required String date,
      required String description,
      required VoidCallback onTap}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
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

import 'package:condoview/components/custom_empty.dart';
import 'package:condoview/screens/administrador/aprovarManutencao/aprovar_manutencao.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:condoview/providers/manutencao_provider.dart';

class VisualizarManutencoesScreen extends StatefulWidget {
  const VisualizarManutencoesScreen({super.key});

  @override
  _VisualizarManutencoesScreenState createState() =>
      _VisualizarManutencoesScreenState();
}

class _VisualizarManutencoesScreenState
    extends State<VisualizarManutencoesScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchManutencoes();
  }

  Future<void> _fetchManutencoes() async {
    try {
      final manutencaoProvider =
          Provider.of<ManutencaoProvider>(context, listen: false);
      await manutencaoProvider.fetchManutencoes();
      manutencaoProvider.startPolling(); 
    } catch (error) {
      print("Erro ao buscar manutenções: $error");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    final manutencaoProvider =
        Provider.of<ManutencaoProvider>(context, listen: false);
    manutencaoProvider.stopPolling(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final manutencaoProvider = Provider.of<ManutencaoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 78, 20, 166),
        foregroundColor: Colors.white,
        title: const Text(
          'Manutenções Pendentes',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Manutenções Pendentes',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: manutencaoProvider.manutencoes.isEmpty
                        ? const CustomEmpty(
                            text: "Nenhuma manutenção pendente.")
                        : ListView.builder(
                            itemCount: manutencaoProvider.manutencoes.length,
                            itemBuilder: (context, index) {
                              final manutencao =
                                  manutencaoProvider.manutencoes[index];
                              return _buildManutencaoCard(
                                context,
                                icon: Icons.build,
                                title: manutencao.tipo,
                                date:
                                    '${manutencao.data.day}/${manutencao.data.month}/${manutencao.data.year}',
                                description: manutencao.descricao,
                                status: manutencao.status,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AprovarManutencaoScreen(
                                        manutencao: manutencao,
                                        manutencaoIndex: index,
                                      ),
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

  Widget _buildManutencaoCard(BuildContext context,
      {required IconData icon,
      required String title,
      required String date,
      required String description,
      required String status,
      required VoidCallback onTap}) {
    Color statusColor;

    switch (status) {
      case 'Aprovada':
        statusColor = Colors.green;
        break;
      case 'Rejeitada':
        statusColor = Colors.red;
        break;
      case 'Pendente':
      default:
        statusColor = Colors.orange;
        break;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: const Color.fromARGB(255, 78, 20, 166)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$date\n$description'),
        trailing: Text(
          status,
          style: TextStyle(
            color: statusColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

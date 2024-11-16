import 'package:condoview/components/custom_button.dart';
import 'package:condoview/components/custom_empty.dart';
import 'package:condoview/models/aviso_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:condoview/providers/aviso_provider.dart';
import 'package:condoview/screens/administrador/avisos/adicionar_avisos_screen.dart';
import 'package:condoview/screens/administrador/avisos/avisos_detalhes_adm_screen.dart';

class VisualizarAvisosScreen extends StatefulWidget {
  const VisualizarAvisosScreen({super.key});

  @override
  _VisualizarAvisosScreenState createState() => _VisualizarAvisosScreenState();
}

class _VisualizarAvisosScreenState extends State<VisualizarAvisosScreen> {
  @override
  void initState() {
    super.initState();
    final avisoProvider = Provider.of<AvisoProvider>(context, listen: false);
    avisoProvider.fetchAvisos();
    avisoProvider.startPolling();
  }

  @override
  void dispose() {
    final avisoProvider = Provider.of<AvisoProvider>(context, listen: false);
    avisoProvider.stopPolling();
    super.dispose();
  }

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
          'Visualizar Avisos',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Consumer<AvisoProvider>(
                builder: (context, avisoProvider, child) {
                  if (avisoProvider.avisos.isEmpty) {
                    return const CustomEmpty(text: "Nenhum aviso disponível.");
                  }
                  return ListView.builder(
                    itemCount: avisoProvider.avisos.length,
                    itemBuilder: (context, index) {
                      final aviso = avisoProvider.avisos[index];
                      return _buildAvisoItem(context, aviso);
                    },
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomButton(
              label: "Adicionar Aviso",
              icon: Icons.add,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdicionarAvisoScreen(),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAvisoItem(BuildContext context, Aviso aviso) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading:
            Icon(aviso.icon, color: const Color.fromARGB(255, 78, 20, 166)),
        title: Text(aviso.title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(aviso.description),
            const SizedBox(height: 4),
            Text(
              aviso.time,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AvisoDetalhesScreen(id: aviso.id),
            ),
          );
        },
      ),
    );
  }
}

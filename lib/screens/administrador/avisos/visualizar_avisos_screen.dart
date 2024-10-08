import 'package:condoview/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:condoview/providers/aviso_provider.dart';
import 'package:condoview/screens/administrador/avisos/adicionar_avisos_screen.dart';
import 'package:condoview/screens/administrador/avisos/avisos_detalhes_adm_screen.dart';

class VisualizarAvisosScreen extends StatelessWidget {
  const VisualizarAvisosScreen({super.key});

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
                    return const Center(
                      child: Text(
                        'Nenhum aviso disponível.',
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: avisoProvider.avisos.length,
                    itemBuilder: (context, index) {
                      final aviso = avisoProvider.avisos[index];
                      return _buildAvisoItem(
                        context,
                        aviso.id,
                        aviso.icon,
                        aviso.title,
                        aviso.description,
                        aviso.time,
                        () {},
                        () {
                          avisoProvider.removeAviso(aviso);
                        },
                      );
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

  Widget _buildAvisoItem(
    BuildContext context,
    String id,
    IconData icon,
    String title,
    String description,
    String time,
    VoidCallback onEdit,
    VoidCallback onDelete,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: Icon(icon, color: const Color.fromARGB(255, 78, 20, 166)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            const SizedBox(height: 4),
            Text(
              time,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AvisoDetalhesScreen(id: id),
            ),
          );
        },
      ),
    );
  }
}

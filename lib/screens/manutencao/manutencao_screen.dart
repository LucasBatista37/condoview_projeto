import 'package:flutter/material.dart';
import 'agendar_manutencao_screen.dart'; // Importa a tela de agendamento

class ManutencaoScreen extends StatelessWidget {
  const ManutencaoScreen({super.key});

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
          'Manutenção',
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
              'Manutenções Programadas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildManutencaoCard(
                    context,
                    icon: Icons.work,
                    title: 'Pintura no Prédio',
                    date: '10/07/2024 até 20/07/2024',
                    status: 'Em andamento',
                  ),
                  _buildManutencaoCard(
                    context,
                    icon: Icons.pool,
                    title: 'Limpeza da Piscina',
                    date: '15/07/2024',
                    status: 'Agendada',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity, // Ocupa toda a largura disponível
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AgendarManutencaoScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor:
                      const Color.fromARGB(255, 78, 20, 166), // Cor do texto
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12), // Borda arredondada
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 16), // Padding interno
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 24), // Ícone de adicionar
                    SizedBox(width: 8), // Espaço entre o ícone e o texto
                    Text(
                      'Agendar manutenção',
                      style: TextStyle(fontSize: 16), // Tamanho da fonte
                    ),
                  ],
                ),
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
      required String status}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: const Color.fromARGB(255, 78, 20, 166)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(date),
        trailing: Text(
          status,
          style: TextStyle(
            color: status == 'Em andamento' ? Colors.green : Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {
          // Você pode adicionar ações aqui se necessário
        },
      ),
    );
  }
}
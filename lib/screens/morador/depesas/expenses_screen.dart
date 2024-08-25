import 'package:flutter/material.dart';

class DespesasScreen extends StatelessWidget {
  const DespesasScreen({super.key});

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
          'Despesas',
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDespesasCard(
              Icons.home,
              'Condomínio',
              'R\$ 200,00',
              'Vencido',
              Colors.red,
            ),
            const SizedBox(height: 20),
            _buildDespesasCard(
              Icons.local_drink,
              'Água',
              'R\$ 300,00',
              'A vencer',
              Colors.orange,
            ),
            const SizedBox(height: 20),
            _buildDespesasCard(
              Icons.electric_car,
              'Luz',
              'R\$ 400,00',
              'Vencido',
              Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDespesasCard(
    IconData icon,
    String title,
    String amount,
    String status,
    Color statusColor,
  ) {
    return Card(
      elevation: 4,
      child: ListTile(
        leading:
            Icon(icon, size: 40, color: const Color.fromARGB(255, 78, 20, 166)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(amount, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 8),
            Text(status, style: TextStyle(color: statusColor)),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {
            // Ação ao clicar no botão
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color.fromARGB(255, 78, 20, 166),
          ),
          child: const Text('Ver boleto'),
        ),
      ),
    );
  }
}

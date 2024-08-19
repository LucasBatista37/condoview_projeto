import 'package:flutter/material.dart';

class EncomendasScreen extends StatelessWidget {
  const EncomendasScreen({super.key});

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
          'Encomendas',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildEncomendaItem(
              context,
              'Carta',
              'AP 301',
              'Chegou 11/07/2024 - 15h00',
              'https://via.placeholder.com/50',
              'Entregue',
            ),
            _buildEncomendaItem(
              context,
              'Caixa',
              'AP 301',
              'Chegou 11/07/2024 - 10h00',
              'https://via.placeholder.com/50',
              'Pendente',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEncomendaItem(BuildContext context, String title,
      String apartment, String time, String imageUrl, String status) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            imageUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(title),
        subtitle: Text('$apartment\n$time'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.arrow_forward),
            const SizedBox(height: 4),
            Text(
              status,
              style: TextStyle(
                color: status == 'Entregue' ? Colors.green : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        isThreeLine: true,
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Detalhes da $title'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Centraliza os elementos
                  children: [
                    Text('Apartamento: $apartment'),
                    Text('Data/Hora: $time'),
                    Text('Status: $status'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('$title marcada como recebida.')),
                        );
                      },
                      child: const Text('Marcar como recebida'),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Fechar'),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

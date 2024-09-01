import 'package:flutter/material.dart';

class BoletoImageScreen extends StatelessWidget {
  final String imageUrl;

  const BoletoImageScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 78, 20, 166),
        title: const Text('Visualizar Boleto'),
        centerTitle: true,
      ),
      body: Center(
        child: Image.network(imageUrl),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class VotacaoScreen extends StatefulWidget {
  final String pautaTitle;
  final String pautaDescricao;

  const VotacaoScreen({
    super.key,
    required this.pautaTitle,
    required this.pautaDescricao,
  });

  @override
  // ignore: library_private_types_in_public_api
  _VotacaoScreenState createState() => _VotacaoScreenState();
}

class _VotacaoScreenState extends State<VotacaoScreen> {
  String _votoEscolhido = 'Abstenção';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 78, 20, 166),
        foregroundColor: Colors.white,
        title: const Text('Votação'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.pautaTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              widget.pautaDescricao,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                RadioListTile<String>(
                  title: const Text('Sim'),
                  value: 'Sim',
                  groupValue: _votoEscolhido,
                  onChanged: (value) {
                    setState(() {
                      _votoEscolhido = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Não'),
                  value: 'Não',
                  groupValue: _votoEscolhido,
                  onChanged: (value) {
                    setState(() {
                      _votoEscolhido = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Abstenção'),
                  value: 'Abstenção',
                  groupValue: _votoEscolhido,
                  onChanged: (value) {
                    setState(() {
                      _votoEscolhido = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Voto "$_votoEscolhido" confirmado!')),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 78, 20, 166),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Confirmar Voto',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

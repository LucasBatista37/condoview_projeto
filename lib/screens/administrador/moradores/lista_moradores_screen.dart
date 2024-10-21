import 'package:condoview/screens/administrador/moradores/adicionar_morador_screen.dart';
import 'package:flutter/material.dart';
import 'editar_morador_screen.dart';

import 'package:condoview/components/custom_button.dart';

class Morador {
  final String nome;
  final String apartamento;
  final String email;
  final String telefone;

  Morador({
    required this.nome,
    required this.apartamento,
    required this.email,
    required this.telefone,
  });
}

class ListaMoradoresScreen extends StatefulWidget {
  const ListaMoradoresScreen({super.key});

  @override
  _ListaMoradoresScreenState createState() => _ListaMoradoresScreenState();
}

class _ListaMoradoresScreenState extends State<ListaMoradoresScreen> {
  List<Morador> moradores = [
    Morador(
      nome: 'Edkarllos Fernando',
      apartamento: '101A',
      email: 'edkarllos@gmail.com',
      telefone: '(11) 98765-4321',
    ),
    Morador(
      nome: 'Maria Oliveira',
      apartamento: '202B',
      email: 'maria.oliveira@gmail.com',
      telefone: '(21) 91234-5678',
    ),
    Morador(
      nome: 'Julio Santos',
      apartamento: '303C',
      email: 'julio.santos@gmail.com',
      telefone: '(31) 93456-7890',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 78, 20, 166),
        foregroundColor: Colors.white,
        title: const Text(
          'Lista de Moradores',
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
            child: ListView.builder(
              itemCount: moradores.length,
              itemBuilder: (context, index) {
                final morador = moradores[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    leading: CircleAvatar(
                      backgroundColor: const Color.fromARGB(255, 78, 20, 166),
                      child: Text(
                        morador.nome[0],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      morador.nome,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Text(
                      'Apartamento: ${morador.apartamento}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          _editMorador(context, morador, index);
                        } else if (value == 'delete') {
                          _confirmarExclusao(context, morador, index);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Text('Editar'),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Excluir'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomButton(
                label: "Adicionar morador",
                icon: Icons.add,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdicionarMoradorScreen(),
                    ),
                  );
                },
              )),
        ],
      ),
    );
  }

  void _editMorador(BuildContext context, Morador morador, int index) async {
    final editedMorador = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditarMoradorScreen(morador: morador),
      ),
    );

    if (editedMorador != null) {
      setState(() {
        moradores[index] = editedMorador;
      });
    }
  }

  void _confirmarExclusao(BuildContext context, Morador morador, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Tem certeza de que deseja excluir "${morador.nome}"?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                moradores.removeAt(index);
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${morador.nome} excluído'),
                ),
              );
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}

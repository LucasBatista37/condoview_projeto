import 'package:condoview/models/usuario_model.dart';
import 'package:condoview/providers/usuario_provider.dart';
import 'package:condoview/screens/administrador/moradores/adicionar_morador_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'editar_morador_screen.dart';
import 'package:condoview/components/custom_button.dart';

class ListaMoradoresScreen extends StatefulWidget {
  const ListaMoradoresScreen({super.key});

  @override
  _ListaMoradoresScreenState createState() => _ListaMoradoresScreenState();
}

class _ListaMoradoresScreenState extends State<ListaMoradoresScreen> {
  List<Usuario> moradores = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final provider = Provider.of<UsuarioProvider>(context, listen: false);
      List<Usuario> users = await provider.getAllUsers();
      setState(() {
        moradores = users;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar usuários: $e')),
      );
    }
  }

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
      body: moradores.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: moradores.length,
                    itemBuilder: (context, index) {
                      final morador = moradores[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 4,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          leading: CircleAvatar(
                            backgroundColor:
                                const Color.fromARGB(255, 78, 20, 166),
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
                            'Apartamento: 103B',
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
                  ),
                ),
              ],
            ),
    );
  }

  void _editMorador(BuildContext context, Usuario morador, int index) async {
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

  void _confirmarExclusao(BuildContext context, Usuario morador, int index) {
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
            onPressed: () async {
              try {
                final provider =
                    Provider.of<UsuarioProvider>(context, listen: false);
                await provider
                    .deleteUser(morador.id); // Usa o ID real do usuário
                setState(() {
                  moradores.removeAt(index);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${morador.nome} excluído'),
                  ),
                );
              } catch (e) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erro ao excluir usuário: $e'),
                  ),
                );
              }
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}

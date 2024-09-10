import 'package:condoview/components/custom_button.dart';
import 'package:condoview/components/custom_empty.dart';
import 'package:condoview/models/assembleia_model.dart';
import 'package:condoview/providers/assembleia_provider.dart';
import 'package:condoview/screens/administrador/criarAssembleia/criar_assembleia_screen.dart';
import 'package:condoview/screens/administrador/criarAssembleia/editar_assembleia_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ListaAssembleiasScreen extends StatelessWidget {
  const ListaAssembleiasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 78, 20, 166),
        foregroundColor: Colors.white,
        title: const Text(
          'Assembleias Criadas',
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
              child: Consumer<AssembleiaProvider>(
                builder: (context, assembleiaProvider, child) {
                  if (assembleiaProvider.assembleias.isEmpty) {
                    return const CustomEmpty(
                        text: "Nenhuma assembleia criada.");
                  }
                  return ListView.builder(
                    itemCount: assembleiaProvider.assembleias.length,
                    itemBuilder: (context, index) {
                      final assembleia = assembleiaProvider.assembleias[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 4,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          title: Text(
                            assembleia.titulo,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          subtitle: Text(
                            'Assunto: ${assembleia.assunto}\nStatus: ${assembleia.status}\nData: ${DateFormat('dd/MM/yyyy').format(assembleia.data)} ${assembleia.horario.format(context)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditarAssembleiaScreen(
                                      assembleia: assembleia,
                                    ),
                                  ),
                                );
                              } else if (value == 'delete') {
                                _confirmarExclusao(context, assembleia);
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
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
                width: double.infinity,
                child: CustomButton(
                  label: "Adicionar Assembleia",
                  icon: Icons.add,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CriarAssembleiaScreen(),
                      ),
                    );
                  },
                )),
          ),
        ],
      ),
    );
  }

  void _confirmarExclusao(BuildContext context, Assembleia assembleia) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content:
            Text('Tem certeza de que deseja excluir "${assembleia.titulo}"?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<AssembleiaProvider>(context, listen: false)
                  .removeAssembleia(assembleia);
              Navigator.of(context).pop();
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}

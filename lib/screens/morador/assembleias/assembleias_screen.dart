import 'package:condoview/components/custom_empty.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/assembleia_model.dart';
import '../../../providers/assembleia_provider.dart';
import 'votar_screen.dart';

class AssembleiasScreen extends StatefulWidget {
  const AssembleiasScreen({super.key});

  @override
  _AssembleiasScreenState createState() => _AssembleiasScreenState();
}

class _AssembleiasScreenState extends State<AssembleiasScreen> {
  bool _isInitialLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAssembleias();
  }

  Future<void> _fetchAssembleias() async {
    try {
      final assembleiaProvider =
          Provider.of<AssembleiaProvider>(context, listen: false);
      await assembleiaProvider.fetchAssembleias();
      assembleiaProvider.startPolling();
    } catch (error) {
      print("Log: Erro ao buscar assembleias: $error");
    } finally {
      setState(() {
        _isInitialLoading = false; 
      });
    }
  }

  @override
  void dispose() {
    final assembleiaProvider =
        Provider.of<AssembleiaProvider>(context, listen: false);
    assembleiaProvider.stopPolling(); 
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
          'Assembleias',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _isInitialLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Consumer<AssembleiaProvider>(
                builder: (context, assembleiaProvider, _) {
                  final assembleias = assembleiaProvider.assembleia;

                  if (assembleias.isEmpty) {
                    return const CustomEmpty(
                      text: "Nenhuma assembleia disponível.",
                    );
                  }

                  return ListView.builder(
                    itemCount: assembleias.length,
                    itemBuilder: (context, index) {
                      final assembleia = assembleias[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        color: assembleia.status == 'Em andamento'
                            ? Colors.green[50]
                            : Colors.grey[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                assembleia.titulo,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Assunto: ${assembleia.assunto}',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Data: ${assembleia.data.day}/${assembleia.data.month}/${assembleia.data.year}',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Horário: ${assembleia.horario.format(context)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  assembleia.status,
                                  style: TextStyle(
                                    color: assembleia.status == 'Em andamento'
                                        ? Colors.green
                                        : Colors.orange,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const Divider(
                                height: 20,
                                thickness: 1,
                              ),
                              _buildPautasList(context, assembleia.pautas),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }

  Widget _buildPautasList(BuildContext context, List<Pauta> pautas) {
    if (pautas.isEmpty) {
      return const CustomEmpty(
        text: "Nenhuma pauta disponível.",
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: pautas.map((pauta) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 2,
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            title: Text(
              pauta.tema,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              pauta.descricao,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color.fromARGB(255, 78, 20, 166),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VotacaoScreen(
                    pautaTitle: pauta.tema,
                    pautaDescricao: pauta.descricao,
                  ),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }
}
import 'package:condoview/components/custom_empty.dart';
import 'package:condoview/screens/morador/avisos/avisos_detalhes_morador_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:condoview/providers/aviso_provider.dart';

class AvisosScreen extends StatefulWidget {
  const AvisosScreen({super.key});

  @override
  _AvisosScreenState createState() => _AvisosScreenState();
}

class _AvisosScreenState extends State<AvisosScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;
  int _previousAvisoCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchAvisos();
  }

  Future<void> _fetchAvisos() async {
    try {
      final avisoProvider = Provider.of<AvisoProvider>(context, listen: false);
      await avisoProvider.fetchAvisos();
      avisoProvider.startPolling();
    } catch (error) {
      print("Erro ao buscar avisos: $error");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

    final avisoProvider = Provider.of<AvisoProvider>(context, listen: false);
    avisoProvider.addListener(_scrollToBottomIfNeeded);
  }

  @override
  void dispose() {
    final avisoProvider = Provider.of<AvisoProvider>(context, listen: false);
    avisoProvider.removeListener(_scrollToBottomIfNeeded);
    avisoProvider.stopPolling();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottomIfNeeded() {
    final avisoProvider = Provider.of<AvisoProvider>(context, listen: false);
    if (avisoProvider.avisos.length > _previousAvisoCount) {
      // Rola para o final da lista se houver novos avisos
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
      _previousAvisoCount = avisoProvider.avisos.length;
    }
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
          'Avisos',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Consumer<AvisoProvider>(
                      builder: (context, avisoProvider, child) {
                        if (avisoProvider.avisos.isEmpty) {
                          return const CustomEmpty(
                            text: "Nenhum aviso disponível.",
                          );
                        }
                        return ListView.builder(
                          controller: _scrollController,
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
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
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
              builder: (context) => AvisosDetalhesMoradorScreen(id: id),
            ),
          );
        },
      ),
    );
  }
}

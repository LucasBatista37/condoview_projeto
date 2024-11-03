import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:condoview/providers/aviso_provider.dart';
import 'package:condoview/models/aviso_model.dart';

class AvisoDetalhesScreen extends StatefulWidget {
  final String id;

  const AvisoDetalhesScreen({super.key, required this.id});

  @override
  _AvisoDetalhesScreenState createState() => _AvisoDetalhesScreenState();
}

class _AvisoDetalhesScreenState extends State<AvisoDetalhesScreen> {
  late Aviso _aviso;
  bool _isEditing = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  IconData? _selectedIcon;

  final List<IconData> _icons = [
    Icons.info,
    Icons.warning,
    Icons.error,
    Icons.help,
    Icons.notifications,
    Icons.favorite,
    Icons.event,
    Icons.group,
  ];

  @override
  void initState() {
    super.initState();
    _loadAviso();
  }

  void _loadAviso() {
    final avisoProvider = Provider.of<AvisoProvider>(context, listen: false);
    _aviso = avisoProvider.getAvisoById(widget.id);

    if (_aviso == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aviso não encontrado.')),
      );
      Navigator.pop(context);
    } else {
      _titleController.text = _aviso.title;
      _descriptionController.text = _aviso.description;
      _dateController.text = _aviso.time;
      _selectedIcon = _aviso.icon;
    }
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveChanges() {
    final avisoProvider = Provider.of<AvisoProvider>(context, listen: false);
    final updatedAviso = _aviso.copyWith(
      title: _titleController.text,
      description: _descriptionController.text,
      icon: _selectedIcon ?? _aviso.icon,
      time: _dateController.text,
    );

    avisoProvider.updateAviso(updatedAviso).then((_) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aviso atualizado com sucesso!')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar aviso: $error')),
      );
    });
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Atualização'),
          content:
              const Text('Tem certeza de que deseja atualizar este aviso?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _saveChanges();
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  void _selectIcon() async {
    final IconData? icon = await showDialog<IconData>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Escolher Ícone'),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _icons.length,
              itemBuilder: (context, index) {
                final IconData icon = _icons[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(icon);
                  },
                  child: Icon(icon, size: 40),
                );
              },
            ),
          ),
        );
      },
    );

    if (icon != null) {
      setState(() {
        _selectedIcon = icon;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 78, 20, 166),
        foregroundColor: Colors.white,
        title: const Text(
          'Detalhes do Aviso',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_isEditing) ...[
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _showConfirmationDialog,
            ),
          ],
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit),
            onPressed: _toggleEditing,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirmar Exclusão'),
                    content: const Text(
                        'Tem certeza de que deseja excluir este aviso?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          final avisoProvider = Provider.of<AvisoProvider>(
                              context,
                              listen: false);
                          avisoProvider.removeAviso(_aviso);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Aviso excluído com sucesso!')),
                          );
                        },
                        child: const Text('Excluir'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _isEditing
                    ? GestureDetector(
                        onTap: _selectIcon,
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedIcon == null
                                    ? 'Selecionar Ícone'
                                    : 'Ícone Selecionado',
                              ),
                              Icon(_selectedIcon ?? Icons.star, size: 24),
                            ],
                          ),
                        ),
                      )
                    : Icon(
                        _aviso.icon,
                        size: 40,
                      ),
                const SizedBox(height: 16),
                _isEditing
                    ? TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Título',
                          border: OutlineInputBorder(),
                        ),
                      )
                    : Text(
                        _aviso.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                const SizedBox(height: 16),
                _isEditing
                    ? TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Descrição',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 5,
                      )
                    : Text(
                        _aviso.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: 'Data',
                    border: OutlineInputBorder(),
                  ),
                  enabled: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

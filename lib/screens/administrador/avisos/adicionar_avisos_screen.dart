import 'package:condoview/components/custom_button.dart';
import 'package:condoview/components/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:condoview/models/aviso_model.dart';
import 'package:condoview/providers/aviso_provider.dart';
import 'package:provider/provider.dart';

class AdicionarAvisoScreen extends StatefulWidget {
  const AdicionarAvisoScreen({super.key});

  @override
  _AdicionarAvisoScreenState createState() => _AdicionarAvisoScreenState();
}

class _AdicionarAvisoScreenState extends State<AdicionarAvisoScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  IconData? _selectedIcon;

  final DateTime _fixedDate = DateTime.now();

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

  final List<String> _iconLabels = [
    'Informação',
    'Aviso',
    'Erro',
    'Ajuda',
    'Notificação',
    'Favorito',
    'Evento',
    'Grupo',
  ];

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
                final String label = _iconLabels[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(icon);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 40),
                      const SizedBox(height: 4),
                      Flexible(
                        child: Text(
                          label,
                          style: const TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2, 
                        ),
                      ),
                    ],
                  ),
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

  void _submit() async {
    final aviso = Aviso(
      id: DateTime.now().toString(),
      icon: _selectedIcon ?? Icons.info,
      title: _titleController.text,
      description: _descriptionController.text,
      time:
          'Enviado dia ${DateTime.now().toLocal().toString().split(' ')[0]} às ${DateTime.now().toLocal().toString().split(' ')[1].split('.')[0]}',
    );

    try {
      await Provider.of<AvisoProvider>(context, listen: false).addAviso(aviso);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aviso adicionado com sucesso!'),
        ),
      );
      Navigator.pop(context);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Falha ao adicionar aviso: $error'),
        ),
      );
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
          'Adicionar Aviso',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Preencha os detalhes do aviso.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _titleController,
                label: "Título do Aviso",
                maxLines: 1,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _descriptionController,
                label: "Descrição",
                maxLines: 5,
              ),
              const SizedBox(height: 16),
              GestureDetector(
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
                      Icon(_selectedIcon ?? Icons.info, size: 24),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Data de Envio: ${_fixedDate.toLocal().toString().split(' ')[0]}',
                    ),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              CustomButton(
                  label: "Adicionar Aviso",
                  icon: Icons.check,
                  onPressed: _submit)
            ],
          ),
        ),
      ),
    );
  }
}

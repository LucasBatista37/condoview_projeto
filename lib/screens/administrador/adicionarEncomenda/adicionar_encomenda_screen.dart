import 'dart:io';

import 'package:condoview/components/custom_button.dart';
import 'package:condoview/components/custom_date_time_picker.dart';
import 'package:condoview/components/custom_image_picker.dart';
import 'package:condoview/components/custom_text_field.dart';
import 'package:condoview/models/encomenda_model.dart';
import 'package:condoview/models/usuario_model.dart';
import 'package:condoview/providers/encomenda_provider.dart';
import 'package:condoview/providers/usuario_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AdicionarEncomendaScreen extends StatefulWidget {
  const AdicionarEncomendaScreen({super.key});

  @override
  _AdicionarEncomendaScreenState createState() =>
      _AdicionarEncomendaScreenState();
}

class _AdicionarEncomendaScreenState extends State<AdicionarEncomendaScreen> {
  final _titleController = TextEditingController();
  final _apartmentController = TextEditingController();
  DateTime? _selectedDateTime;
  XFile? _imageFile;
  String? _selectedType;
  Usuario? _selectedUser;
  List<Usuario> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final usuarios =
          await Provider.of<UsuarioProvider>(context, listen: false)
              .getAllUsers();
      setState(() {
        _users = usuarios;
      });
      debugPrint("Usuários carregados: ${_users.map((e) => e.nome).toList()}");
    } catch (e) {
      debugPrint("Erro ao carregar usuários: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar usuários.')),
      );
    }
  }

  void _submit() async {
    if (_titleController.text.isEmpty ||
        _apartmentController.text.isEmpty ||
        _selectedDateTime == null ||
        _imageFile == null ||
        _selectedUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos.')),
      );
      return;
    }

    if (!await File(_imageFile!.path).exists()) {
      debugPrint("Arquivo de imagem não existe: ${_imageFile!.path}");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Arquivo de imagem inválido.')),
      );
      return;
    }

    debugPrint("Arquivo de imagem válido: ${_imageFile!.path}");
    debugPrint(
        "Usuário selecionado: ID=${_selectedUser?.id}, Nome=${_selectedUser?.nome}");

    final encomenda = Encomenda(
      title: _titleController.text,
      apartment: _apartmentController.text,
      time: _selectedDateTime!.toIso8601String(),
      imagePath: _imageFile!.path,
      status: _selectedType ?? 'Pendente',
      usuarioId: _selectedUser!.id,
      usuarioNome: _selectedUser!.nome,
    );

    debugPrint("Encomenda criada: ${encomenda.toJson()}");

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      await Provider.of<EncomendasProvider>(context, listen: false)
          .addEncomenda(encomenda);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Encomenda adicionada com sucesso!')),
      );

      Navigator.of(context).pop(); // Fechar diálogo
      Navigator.of(context).pop(); // Voltar para tela anterior
    } catch (error) {
      Navigator.of(context).pop(); // Fechar diálogo
      debugPrint("Erro no envio da encomenda: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao adicionar encomenda.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 78, 20, 166),
        foregroundColor: Colors.white,
        title: const Text('Adicionar Encomenda'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Preencher Dados da Encomenda',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CustomTextField(controller: _titleController, label: "Título"),
            const SizedBox(height: 16),
            CustomTextField(
                controller: _apartmentController, label: "Apartamento"),
            const SizedBox(height: 16),
            CustomDateTimePicker(
              onDateTimeChanged: (dateTime) {
                setState(() {
                  _selectedDateTime = dateTime;
                });
              },
            ),
            const SizedBox(height: 16),
            CustomImagePicker(
              onImageSelected: (image) {
                setState(() {
                  _imageFile = image;
                });
              },
              selectedImage: _imageFile,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Usuario>(
              decoration: const InputDecoration(
                labelText: "Selecione o Usuário",
                border: OutlineInputBorder(),
              ),
              items: _users
                  .map(
                    (user) => DropdownMenuItem<Usuario>(
                      value: user,
                      child: Text(user.nome),
                    ),
                  )
                  .toList(),
              onChanged: (user) {
                setState(() {
                  _selectedUser = user;
                });
              },
              value: _selectedUser,
            ),
            const SizedBox(height: 20),
            CustomButton(
              label: "Adicionar Encomenda",
              icon: Icons.add,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

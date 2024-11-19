import 'dart:io';

import 'package:condoview/components/custom_button.dart';
import 'package:condoview/components/custom_date_time_picker.dart';
import 'package:condoview/components/custom_image_picker.dart';
import 'package:condoview/components/custom_text_field.dart';
import 'package:condoview/models/encomenda_model.dart';
import 'package:condoview/providers/encomenda_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AdicionarEncomendaScreen extends StatefulWidget {
  const AdicionarEncomendaScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdicionarEncomendaScreenState createState() =>
      _AdicionarEncomendaScreenState();
}

class _AdicionarEncomendaScreenState extends State<AdicionarEncomendaScreen> {
  final _titleController = TextEditingController();
  final _apartmentController = TextEditingController();
  DateTime? _selectedDateTime;
  XFile? _imageFile;
  String? _selectedType;

  void _submit() async {
    if (_titleController.text.isEmpty ||
        _apartmentController.text.isEmpty ||
        _selectedDateTime == null ||
        _imageFile == null) {
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
    } else {
      debugPrint("Arquivo de imagem válido: ${_imageFile!.path}");
    }

    final encomenda = Encomenda(
      title: _titleController.text,
      apartment: _apartmentController.text,
      time: _selectedDateTime!.toIso8601String(),
      imagePath: _imageFile!.path,
      status: _selectedType ?? 'Pendente',
    );

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

      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } catch (error) {
      Navigator.of(context).pop();
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
            const SizedBox(height: 20),
            CustomButton(
                label: "Adicionar Encomenda",
                icon: Icons.add,
                onPressed: _submit)
          ],
        ),
      ),
    );
  }
}

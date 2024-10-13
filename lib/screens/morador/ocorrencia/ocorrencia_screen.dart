import 'package:condoview/components/custom_button.dart';
import 'package:condoview/components/custom_data_picker.dart';
import 'package:condoview/components/custom_image_picker.dart';
import 'package:condoview/components/custom_text_field.dart';
import 'package:condoview/providers/ocorrencia_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class OcorrenciaScreen extends StatefulWidget {
  const OcorrenciaScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OcorrenciaScreenState createState() => _OcorrenciaScreenState();
}

class _OcorrenciaScreenState extends State<OcorrenciaScreen> {
  final TextEditingController _motivoController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  DateTime? _selectedDate;
  XFile? _image;

  void _submit() {
    if (_motivoController.text.isEmpty ||
        _descricaoController.text.isEmpty ||
        _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos.'),
        ),
      );
      return;
    }

    print('Dados a serem enviados:');
    print('Motivo: ${_motivoController.text}');
    print('Descrição: ${_descricaoController.text}');
    print('Data: ${_selectedDate}');
    print(
        'Imagem: ${_image != null ? _image!.path : 'Nenhuma imagem selecionada'}');

    Provider.of<OcorrenciaProvider>(context, listen: false)
        .addOcorrencia(
      motivo: _motivoController.text,
      descricao: _descricaoController.text,
      data: _selectedDate!,
      imagem: _image != null ? File(_image!.path) : null,
    )
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ocorrência enviada com sucesso!'),
        ),
      );
      Navigator.pop(context);
    }).catchError((error) {
      print('Erro no catch: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao enviar a ocorrência.'),
        ),
      );
    });
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
          'Ocorrências',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Relatar Nova Ocorrência',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CustomTextField(label: 'Motivo', controller: _motivoController),
            const SizedBox(height: 16),
            CustomTextField(
                label: 'Descrição',
                controller: _descricaoController,
                maxLines: 5),
            const SizedBox(height: 16),
            CustomDataPicker(
              onDateSelected: (date) {
                setState(() {
                  _selectedDate = date;
                });
              },
              selectedDate: _selectedDate,
            ),
            const SizedBox(height: 16),
            CustomImagePicker(
              onImageSelected: (image) {
                setState(() {
                  _image = image;
                });
              },
              selectedImage: _image,
            ),
            const SizedBox(height: 16),
            CustomButton(
                label: "Enviar Ocorrência",
                icon: Icons.send,
                onPressed: _submit)
          ],
        ),
      ),
    );
  }
}

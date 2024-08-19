import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatGeralScreen extends StatefulWidget {
  const ChatGeralScreen({super.key});

  @override
  _ChatGeralScreenState createState() => _ChatGeralScreenState();
}

class _ChatGeralScreenState extends State<ChatGeralScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _image;
  final List<Widget> _messages = []; // Lista de mensagens
  String? _fileName; // Nome do arquivo selecionado

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
          'Chat Geral',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return _messages[index];
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.camera_alt),
                      onPressed: _pickImageFromCamera,
                    ),
                    IconButton(
                      icon: const Icon(Icons.attach_file),
                      onPressed: _pickFile,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Mensagem',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_image != null ||
              _fileName !=
                  null) // Exibir a área sobreposta se houver imagem ou arquivo
            Positioned(
              left: 0,
              right: 0,
              bottom: 80,
              child: Container(
                color: Colors.black.withOpacity(0.5),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_image != null) ...[
                      Image.file(
                        _image!,
                        height:
                            200, // Ajuste o tamanho da imagem conforme necessário
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ] else if (_fileName != null) ...[
                      // Exibir uma mensagem ou ícone para arquivos que não são imagens
                      const Icon(Icons.attach_file,
                          color: Colors.white, size: 40),
                      Text(
                        'Arquivo selecionado: $_fileName',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _image = null; // Limpar imagem
                            _fileName = null; // Limpar nome do arquivo
                          });
                        },
                        child: const Text('Remover'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    final status = await Permission.photos.request();

    if (status.isGranted) {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _fileName =
              null; // Limpar nome do arquivo se uma imagem for selecionada
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permissão para acessar fotos negada')),
      );
    }
  }

  Future<void> _pickImageFromCamera() async {
    final status = await Permission.camera.request();

    if (status.isGranted) {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _fileName =
              null; // Limpar nome do arquivo se uma imagem for selecionada
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permissão para acessar a câmera negada')),
      );
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _image = null; // Limpar imagem se um arquivo for selecionado
        _fileName = result.files.single.name;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhum arquivo selecionado')),
      );
    }
  }

  void _sendMessage() {
    final message = _messageController.text.trim();

    if (message.isNotEmpty || _image != null || _fileName != null) {
      setState(() {
        _messages.add(
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (_image != null) ...[
                    Image.file(_image!),
                    const SizedBox(height: 8),
                  ],
                  if (_fileName != null) ...[
                    Text('Arquivo selecionado: $_fileName'),
                    const SizedBox(height: 8),
                  ],
                  Text(message),
                ],
              ),
            ),
          ),
        );
        _messageController.clear();
        _image = null; // Limpar imagem após envio
        _fileName = null; // Limpar nome do arquivo após envio
      });
    }
  }
}

import 'dart:io';
import 'package:condoview/providers/chat_provider.dart';
import 'package:condoview/providers/usuario_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  String? _fileName;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    try {
      print("Tentando carregar mensagens...");
      await Provider.of<ChatProvider>(context, listen: false)
          .fetchMessages(context);
      print("Mensagens carregadas com sucesso.");
    } catch (error) {
      print("Erro ao carregar mensagens: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar mensagens: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final usuarioProvider =
        Provider.of<UsuarioProvider>(context, listen: false);
    final messages = chatProvider.messages;

    final userId = usuarioProvider.userId;
    final currentName = usuarioProvider.currentName;

    print("Usuário atual: ID = $userId, Nome = $currentName");

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
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return Align(
                      alignment: message.userId == userId
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: message.userId == userId
                              ? Colors.deepPurple.shade200
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (message.imageUrl != null)
                              Image.network(message.imageUrl!),
                            if (message.fileUrl != null)
                              Row(
                                children: [
                                  const Icon(Icons.attach_file, size: 20),
                                  const SizedBox(width: 4),
                                  Text('Arquivo: ${message.fileUrl}'),
                                ],
                              ),
                            Text(message.message),
                            const SizedBox(height: 4),
                            Text(
                              message.userName,
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey.shade600),
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
                      onPressed: () => _sendMessage(userId, currentName),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_image != null || _fileName != null)
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
                    if (_image != null)
                      Image.file(
                        _image!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    if (_fileName != null)
                      Row(
                        children: [
                          const Icon(Icons.attach_file, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            'Arquivo: $_fileName',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _image = null;
                            _fileName = null;
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

  Future<void> _pickImageFromCamera() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _fileName = null;
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
        _image = null;
        _fileName = result.files.single.name;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhum arquivo selecionado')),
      );
    }
  }

  Future<void> _sendMessage(String userId, String userName) async {
    final message = _messageController.text.trim();
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    print("Enviando mensagem...");
    print("userId: $userId");
    print("userName: $userName");
    print("message: $message");
    print("imagePath: ${_image?.path}");
    print("fileName: $_fileName");

    try {
      await chatProvider.sendMessage(
        context,
        message,
        _image?.path,
        _fileName,
        userId,
        userName,
      );
      print("Mensagem enviada com sucesso.");
      _messageController.clear();
      setState(() {
        _image = null;
        _fileName = null;
      });
    } catch (error) {
      print("Erro ao enviar mensagem: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao enviar mensagem: $error')),
      );
    }
  }
}

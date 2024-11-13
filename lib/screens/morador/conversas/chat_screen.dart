import 'dart:io';
import 'package:condoview/providers/personal_chat_provider.dart';
import 'package:condoview/providers/usuario_provider.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String name;
  final String receiverId;

  const ChatScreen({super.key, required this.name, required this.receiverId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _image;
  String? _fileName;
  List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    try {
      final personalChatProvider =
          Provider.of<PersonalChatProvider>(context, listen: false);

      await personalChatProvider.fetchMessages(context, widget.receiverId);

      setState(() {
        _messages = personalChatProvider.messages
            .map((messageModel) => ChatMessage(
                  text: messageModel.text,
                  isMe: messageModel.isMe,
                  image: messageModel.image,
                  fileName: messageModel.fileName,
                ))
            .toList();
      });

      print("Log: Mensagens carregadas e exibidas na UI");
    } catch (error) {
      print("Log: Erro ao buscar mensagens: $error");
    }
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

  void _sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) {
      print("Log: Mensagem está vazia. Por favor, digite uma mensagem.");
      return;
    }

    print("Log: Texto da mensagem: $messageText");
    print("Log: Caminho da imagem: ${_image?.path}");
    print("Log: Nome do arquivo: $_fileName");

    final personalChatProvider =
        Provider.of<PersonalChatProvider>(context, listen: false);
    final usuarioProvider =
        Provider.of<UsuarioProvider>(context, listen: false);
    final userName = usuarioProvider.usuario?.nome ?? "Desconhecido";

    print("Log: Chamando sendMessage no PersonalChatProvider");
    print("Log: Nome do destinatário: ${widget.name}");
    print("Log: ID do destinatário: ${widget.receiverId}");
    print("Log: Nome do usuário atual: $userName");

    await personalChatProvider.sendMessage(
      context,
      messageText,
      _image?.path,
      null,
      widget.receiverId,
      userName,
    );

    setState(() {
      _messages.add(ChatMessage(
        text: messageText,
        isMe: true,
        image: _image,
        fileName: _fileName,
      ));
      _messageController.clear();
      _image = null;
      _fileName = null;
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
        title: Text(widget.name),
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
                    final message = _messages[index];
                    return Align(
                      alignment: message.isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: message.isMe
                              ? Colors.deepPurple.shade200
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (message.image != null) ...[
                              Image.file(
                                message.image!,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(height: 8),
                            ],
                            if (message.fileName != null) ...[
                              const Icon(Icons.attach_file, size: 40),
                              Text(
                                'Arquivo selecionado: ${message.fileName}',
                              ),
                              const SizedBox(height: 8),
                            ],
                            Text(
                              message.text,
                              style: TextStyle(
                                color: message.isMe
                                    ? const Color.fromARGB(255, 0, 0, 0)
                                    : Colors.black,
                              ),
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
                      onPressed: _sendMessage,
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
                    if (_image != null) ...[
                      Image.file(
                        _image!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ] else if (_fileName != null) ...[
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
}

class ChatMessage {
  final String text;
  final bool isMe;
  final File? image;
  final String? fileName;

  ChatMessage({
    required this.text,
    required this.isMe,
    this.image,
    this.fileName,
  });
}

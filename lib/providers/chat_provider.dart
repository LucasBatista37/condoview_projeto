import 'dart:convert';
import 'package:condoview/models/chat_message.dart';
import 'package:condoview/providers/usuario_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ChatProvider with ChangeNotifier {
  final String _baseUrl = 'https://backend-condoview.onrender.com';

  List<ChatMessage> _messages = [];

  List<ChatMessage> get messages => _messages;

  // Adicione o contexto para acessar o UsuarioProvider
  Future<void> fetchMessages(BuildContext context) async {
    try {
      // Use o UsuarioProvider para obter o token
      final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
      final token = await usuarioProvider.getToken();
      print("Log: Token usado para buscar mensagens: $token");

      final url = Uri.parse('$_baseUrl/api/users/admin/chat');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print(
          "Log: Status Code da resposta de fetchMessages: ${response.statusCode}");
      print("Log: Corpo da resposta de fetchMessages: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _messages = data.map((json) => ChatMessage.fromJson(json)).toList();
        print("Log: Mensagens carregadas com sucesso: $_messages");
        notifyListeners();
      } else {
        print(
            "Log: Erro ao carregar mensagens. Status Code: ${response.statusCode}");
        throw Exception('Erro ao carregar mensagens');
      }
    } catch (error) {
      print("Log: Erro ao buscar mensagens: $error");
      throw error;
    }
  }

  Future<void> sendMessage(
      BuildContext context,
      String message,
      String? imagePath,
      String? filePath,
      String userId,
      String userName) async {
    final url = Uri.parse('$_baseUrl/api/users/chat');

    try {
      // Use o UsuarioProvider para obter o token
      final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
      final token = await usuarioProvider.getToken();
      print("Log: Token usado para enviar mensagem: $token");

      var request = http.MultipartRequest('POST', url);
      request.fields['message'] = message;
      request.fields['userId'] = userId;
      request.fields['userName'] = userName;

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'application/json';

      if (imagePath != null) {
        print("Log: Adicionando imagem ao request: $imagePath");
        request.files
            .add(await http.MultipartFile.fromPath('image', imagePath));
      }

      if (filePath != null) {
        print("Log: Adicionando arquivo ao request: $filePath");
        request.files.add(await http.MultipartFile.fromPath('file', filePath));
      }

      print("Log: Enviando mensagem com request: ${request.fields}");

      final response = await request.send();
      print(
          "Log: Status Code da resposta de sendMessage: ${response.statusCode}");

      if (response.statusCode == 201) {
        final respStr = await response.stream.bytesToString();
        final jsonResponse = json.decode(respStr);
        final newMessage = ChatMessage.fromJson(jsonResponse);

        print("Log: Mensagem enviada com sucesso: $newMessage");

        _messages.add(newMessage);
        notifyListeners();
      } else {
        print(
            "Log: Erro ao enviar mensagem. Status Code: ${response.statusCode}");
        throw Exception('Erro ao enviar mensagem: ${response.statusCode}');
      }
    } catch (error) {
      print("Log: Erro ao enviar mensagem: $error");
      throw Exception('Erro ao enviar mensagem: $error');
    }
  }
}

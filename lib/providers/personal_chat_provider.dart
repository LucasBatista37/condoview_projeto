import 'dart:convert';
import 'package:condoview/models/personal_chat_message_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:condoview/providers/usuario_provider.dart';

class PersonalChatProvider with ChangeNotifier {
  final String _baseUrl = 'https://backend-condoview.onrender.com';

  List<PersonalChatMessageModel> _messages = [];

  List<PersonalChatMessageModel> get messages => _messages;

  Future<void> fetchMessages(BuildContext context, String userId) async {
    try {
      final usuarioProvider =
          Provider.of<UsuarioProvider>(context, listen: false);
      final token = await usuarioProvider.getToken();
      final currentUserId = usuarioProvider.userId;

      print("Log: Token usado para buscar mensagens: $token");
      print("Log: ID do usuário atual: $currentUserId");

      final url = Uri.parse('$_baseUrl/api/users/personal-chat/$userId');

      print("Log: URL para buscar mensagens: $url");

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
        print("Log: Dados decodificados: $data");

        _messages = data
            .map((json) =>
                PersonalChatMessageModel.fromJson(json, currentUserId))
            .cast<PersonalChatMessageModel>()
            .toList();

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
    String receiverId,
    String userName,
  ) async {
    final url = Uri.parse('$_baseUrl/api/users/personal-chat');

    try {
      final usuarioProvider =
          Provider.of<UsuarioProvider>(context, listen: false);
      final token = await usuarioProvider.getToken();

      print("Log: Token usado para enviar mensagem: $token");
      print("Log: Dados enviados na mensagem:");
      print("Log: message: $message");
      print("Log: receiverId (ID do destinatário): $receiverId");
      print("Log: userName: $userName");
      print("Log: imagePath: $imagePath");
      print("Log: filePath: $filePath");

      var request = http.MultipartRequest('POST', url);
      request.fields['message'] = message;
      request.fields['receiver'] = receiverId;
      request.fields['userName'] = userName;

      request.headers['Authorization'] = 'Bearer $token';

      if (imagePath != null) {
        print("Log: Adicionando imagem ao request: $imagePath");
        request.files
            .add(await http.MultipartFile.fromPath('image', imagePath));
      }

      if (filePath != null) {
        print("Log: Adicionando arquivo ao request: $filePath");
        request.files.add(await http.MultipartFile.fromPath('file', filePath));
      }

      final response = await request.send();
      print(
          "Log: Status Code da resposta de sendMessage: ${response.statusCode}");

      if (response.statusCode == 201) {
        final respStr = await response.stream.bytesToString();
        final jsonResponse = json.decode(respStr);

        final newMessage = PersonalChatMessageModel.fromJson(
            jsonResponse, usuarioProvider.userId);

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

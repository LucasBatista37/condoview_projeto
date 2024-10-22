import 'dart:convert';
import 'package:condoview/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatProvider with ChangeNotifier {
  List<ChatMessage> _messages = [];
  final String baseUrl = 'https://backend-condoview.onrender.com';

  List<ChatMessage> get messages => _messages;

  Future<void> fetchMessages() async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/api/users/admin/chat'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _messages = data.map((json) => ChatMessage.fromJson(json)).toList();
        notifyListeners();
      } else {
        throw Exception('Erro ao carregar mensagens');
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> sendMessage(String message, String? imagePath, String? filePath,
      String userId, String userName) async {
    final url = Uri.parse('$baseUrl/api/users/chat');

    var request = http.MultipartRequest('POST', url);
    request.fields['message'] = message;
    request.fields['userId'] = userId;
    request.fields['userName'] = userName;

    if (imagePath != null) {
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    }

    if (filePath != null) {
      request.files.add(await http.MultipartFile.fromPath('file', filePath));
    }

    try {
      final response = await request.send();
      if (response.statusCode == 201) {
        final respStr = await response.stream.bytesToString();
        final jsonResponse = json.decode(respStr);
        final newMessage = ChatMessage.fromJson(jsonResponse);

        _messages.add(newMessage);
        notifyListeners();
      } else {
        throw Exception('Erro ao enviar mensagem: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Erro ao enviar mensagem: $error');
    }
  }

  Future<void> deleteMessage(String id) async {
    final response =
        await http.delete(Uri.parse('$baseUrl/api/users/chat/$id'));

    if (response.statusCode == 200) {
      _messages.removeWhere((message) => message.id == id);
      notifyListeners();
    } else {
      throw Exception('Erro ao deletar mensagem');
    }
  }
}

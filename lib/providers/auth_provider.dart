import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:condoview/models/usuario_model.dart';

class AuthProvider with ChangeNotifier {
  
  final String _baseUrl = 'http://10.0.1.9:5000';
  String? _token;
  Usuario? _usuario;

  String? get token => _token;
  Usuario? get usuario => _usuario;

  Future<String> createUser(String nome, String email, String senha) async {
    final url = Uri.parse('$_baseUrl/api/users/register');

    print('Tentando criar usuário: nome=$nome, email=$email');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nome': nome,
          'email': email,
          'senha': senha,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['_id'] != null) {
          _usuario = Usuario.fromJson(data);
          _token = data['token']; // Armazena o token
          notifyListeners();
          print('Token recebido: $_token');
          return _token!;
        } else {
          throw Exception(
              'ID do usuário não encontrado na resposta: ${response.body}');
        }
      } else {
        print('Resposta do servidor: ${response.body}');
        throw Exception('Erro ao criar conta: ${response.body}');
      }
    } catch (e) {
      print('Erro na requisição: $e');
      throw Exception('Erro ao criar conta: $e');
    }
  }

  // Método para fazer login (ou qualquer outro método que use o token)
  Future<void> login(String email, String senha) async {
    final url = Uri.parse('$_baseUrl/api/users/login');

    print('Tentando fazer login: email=$email');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'senha': senha,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _usuario = Usuario.fromJson(data);
        _token = data['token'];
        notifyListeners();
      } else {
        throw Exception('Erro ao fazer login: ${response.body}');
      }
    } catch (e) {
      print('Erro na requisição: $e');
      throw Exception('Erro ao fazer login: $e');
    }
  }

  void logout() {
    _token = null;
    _usuario = null;
    notifyListeners();
  }
}

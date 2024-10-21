import 'package:condoview/models/usuario_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UsuarioProvider with ChangeNotifier {
  final String _baseUrl = 'http://10.0.1.9:5000';

  String _userName = '';
  String _userProfileImage = '';
  Usuario? _usuario;
  String? _token;

  String get userName => _userName;
  String get userProfileImage => _userProfileImage;
  Usuario? get usuario => _usuario;
  String? get token => _token;

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
          _userName = nome;
          _usuario = Usuario.fromJson(data);
          notifyListeners();

          if (data['token'] != null) {
            _token = data['token'];
            print('Token recebido: $_token');
            return _token!;
          } else {
            throw Exception(
                'Token não encontrado na resposta: ${response.body}');
          }
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

  Future<void> login(String email, String senha) async {
    final url = Uri.parse('$_baseUrl/api/users/login');

    print('Tentando autenticar usuário: email=$email, senha=$senha');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'senha': senha,
        }),
      );

      print('Status da resposta: ${response.statusCode}');
      print('Corpo da resposta: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print('Dados do usuário recebidos: $data');
        _usuario = Usuario.fromJson(data);
        _token = data['token']; // Armazenando o token
        notifyListeners();

        if (_usuario != null) {
          print('Usuário autenticado com sucesso: ${_usuario!.id}');
        } else {
          print('Usuário não autenticado.');
        }
      } else {
        print('Erro ao autenticar: ${response.statusCode}');
        throw Exception('Erro ao autenticar: ${response.body}');
      }
    } catch (e) {
      print('Erro na requisição de login: $e');
      throw Exception('Erro ao autenticar: $e');
    }
  }

  Future<void> update(
      {String? nome, String? senha, String? profileImage}) async {
    final url = Uri.parse('$_baseUrl/api/users/${_usuario?.id}');
    final requestBody = <String, dynamic>{};

    if (nome != null) {
      requestBody['nome'] = nome;
    }

    if (senha != null) {
      requestBody['senha'] = senha;
    }

    if (profileImage != null) {
      requestBody['profileImage'] = profileImage;
    }

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token'
      }, // Adicionando o token na atualização
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _usuario = Usuario.fromJson(data);
      _userName = data['nome'] ?? _userName;
      _userProfileImage = data['profileImage'] ?? _userProfileImage;
      notifyListeners();
    } else {
      throw Exception('Erro ao atualizar usuário: ${response.body}');
    }
  }
}

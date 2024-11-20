import 'package:condoview/models/usuario_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UsuarioProvider with ChangeNotifier {
  final String _baseUrl = 'https://backend-condoview.onrender.com';

  String _userName = '';
  String _userProfileImage = '';
  Usuario? _usuario;
  String? _token;

  String get userName => _userName;
  String get userProfileImage => _userProfileImage;
  Usuario? get usuario => _usuario;
  String? get token => _token;

  UsuarioProvider() {
    _loadTokenFromStorage();
  }

  Future<void> _loadTokenFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('authToken');
    if (_token != null) {
      print("Log: Token carregado do armazenamento: $_token");
      await getCurrentUser();
    }
  }

  Future<void> _saveTokenToStorage(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
    print("Log: Token salvo no armazenamento: $token");
  }

  Future<void> _removeTokenFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    print("Log: Token removido do armazenamento.");
  }

  Future<String> createUser(String nome, String email, String senha) async {
    final url = Uri.parse('$_baseUrl/api/users/register');

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
        _usuario = Usuario.fromJson(data);
        _token = data['token'];

        print("Log: Token definido após o registro: $_token");
        await _saveTokenToStorage(_token!);

        await getCurrentUser();
        notifyListeners();

        return _token!;
      } else {
        throw Exception('Erro ao criar conta: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro ao criar conta: $e');
    }
  }

  Future<void> login(String email, String senha) async {
    final url = Uri.parse('$_baseUrl/api/users/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'senha': senha,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        _token = data['token'];

        print("Log: Token definido após o login: $_token");
        await _saveTokenToStorage(_token!);

        await getCurrentUser();
        notifyListeners();
      } else {
        throw Exception('Erro ao autenticar: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro ao autenticar: $e');
    }
  }

  Future<String> getToken() async {
    if (_token != null) {
      print("Log: Token encontrado: $_token");
      return _token!;
    } else {
      print("Log: Token não encontrado. O usuário não está autenticado.");
      throw Exception("Token não encontrado. O usuário não está autenticado.");
    }
  }

  Future<void> update({
    String? nome,
    String? senha,
    String? telefone,
    String? profileImage,
  }) async {
    if (_usuario == null) {
      print('Log: Tentativa de atualizar sem autenticação');
      throw Exception('Usuário não autenticado. Não é possível atualizar.');
    }

    final url = Uri.parse('$_baseUrl/api/users/update');

    try {
      print('Log: Iniciando requisição de atualização');
      var request = http.MultipartRequest('PUT', url);

      request.headers['Authorization'] = 'Bearer $_token';

      if (nome != null && nome.isNotEmpty) {
        print('Log: Adicionando nome ao request: $nome');
        request.fields['nome'] = nome;
      }
      if (senha != null && senha.isNotEmpty) {
        print('Log: Adicionando senha ao request');
        request.fields['senha'] = senha;
      }
      if (telefone != null && telefone.isNotEmpty) {
        print('Log: Adicionando telefone ao request: $telefone');
        request.fields['telefone'] = telefone;
      }
      if (profileImage != null) {
        print('Log: Adicionando imagem de perfil ao request: $profileImage');
        request.files.add(
          await http.MultipartFile.fromPath('profileImage', profileImage),
        );
      }

      print('Log: Enviando requisição para $_baseUrl/api/users/update');
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('Log: Status Code da resposta: ${response.statusCode}');
      print('Log: Corpo da resposta: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Log: Dados recebidos após atualização: $data');

        _usuario = Usuario.fromJson(data);
        _userName = _usuario!.nome;

        if (_usuario!.profileImageUrl != null &&
            _usuario!.profileImageUrl!.isNotEmpty) {
          _userProfileImage =
              '$_baseUrl/uploads/users/${_usuario!.profileImageUrl}';
          print('Log: URL da imagem de perfil atualizada: $_userProfileImage');
        } else {
          _userProfileImage = '';
          print('Log: Imagem de perfil não encontrada ou removida.');
        }

        print('Log: Atualização de perfil concluída com sucesso.');
        notifyListeners();
      } else {
        print(
            'Log: Falha na atualização - Status Code: ${response.statusCode}, Body: ${response.body}');
        throw Exception('Erro ao atualizar usuário: ${response.body}');
      }
    } catch (e) {
      print('Log: Exceção ao atualizar usuário: $e');
      throw Exception('Erro ao atualizar usuário: $e');
    }
  }

  Future<void> getCurrentUser() async {
    if (_token == null) {
      print("Log: Tentativa de obter dados do usuário sem token.");
      throw Exception(
          'Usuário não autenticado. Não é possível obter os dados.');
    }

    final url = Uri.parse('$_baseUrl/api/users/profile');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _usuario = Usuario.fromJson(data);
        _userName = _usuario!.nome;

        if (_usuario!.profileImageUrl != null &&
            _usuario!.profileImageUrl!.isNotEmpty) {
          _userProfileImage =
              '$_baseUrl/uploads/users/${_usuario!.profileImageUrl}';
        } else {
          _userProfileImage = '';
        }

        notifyListeners();
      } else {
        throw Exception('Erro ao obter dados do usuário: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro ao obter dados do usuário: $e');
    }
  }

  Future<Usuario?> getUserById(String id) async {
    final url = Uri.parse('$_baseUrl/api/users/$id');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Usuario.fromJson(data);
      } else {
        throw Exception('Erro ao buscar usuário por ID: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro ao buscar usuário por ID: $e');
    }
  }

  Future<List<Usuario>> getAllUsers() async {
    final url = Uri.parse('$_baseUrl/api/users/admin/all');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        List<Usuario> users =
            data.map((json) => Usuario.fromJson(json)).toList();
        return users;
      } else {
        throw Exception('Erro ao buscar todos os usuários: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro ao buscar todos os usuários: $e');
    }
  }

  Future<void> deleteUser(String id) async {
    final url = Uri.parse('$_baseUrl/api/users/admin/$id');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Erro ao excluir o usuário: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro ao excluir o usuário: $e');
    }
  }

  String get userId => _usuario?.id ?? '';
  String get currentName => _usuario?.nome ?? 'Usuário';
}

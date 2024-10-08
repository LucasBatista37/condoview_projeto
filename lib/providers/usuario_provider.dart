import 'package:condoview/models/usuario_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

class UsuarioProvider with ChangeNotifier {
  Usuario? _usuario;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Usuario? get usuario => _usuario;

  set usuario(Usuario? novoUsuario) {
    _usuario = novoUsuario;
    notifyListeners();
  }

  String get userName => _usuario?.nome ?? 'Usuário';
  String? get userProfileImage => _usuario?.profileImageUrl;

  Future<String> createUser(String nome, String email, String senha,
      {String? profileImageUrl}) async {
    const uuid = Uuid();
    final id = uuid.v4();
    final token = senha;

    _usuario = Usuario(
      id: id,
      nome: nome,
      email: email,
      token: token,
      profileImageUrl: profileImageUrl,
    );

    await _storage.write(key: 'auth_token', value: token);
    await _storage.write(key: 'user_id', value: id);
    await _storage.write(key: 'user_name', value: nome);
    await _storage.write(key: 'user_email', value: email);
    if (profileImageUrl != null) {
      await _storage.write(key: 'user_profile_image', value: profileImageUrl);
    }

    notifyListeners();

    return id;
  }

  Future<Usuario?> login(String email, String senha) async {
    final token = await _storage.read(key: 'auth_token');
    final userId = await _storage.read(key: 'user_id');
    final userName = await _storage.read(key: 'user_name');
    final userEmail = await _storage.read(key: 'user_email');
    final profileImageUrl = await _storage.read(key: 'user_profile_image');

    if (email == userEmail && senha == token) {
      _usuario = Usuario(
        id: userId!,
        nome: userName!,
        email: userEmail!,
        token: token!,
        profileImageUrl: profileImageUrl,
      );

      notifyListeners();

      return _usuario;
    } else {
      throw Exception('Credenciais inválidas');
    }
  }

  Future<void> loadUserFromStorage() async {
    final token = await _storage.read(key: 'auth_token');
    final userId = await _storage.read(key: 'user_id');
    final userName = await _storage.read(key: 'user_name');
    final userEmail = await _storage.read(key: 'user_email');
    final profileImageUrl = await _storage.read(key: 'user_profile_image');

    if (token != null &&
        userId != null &&
        userName != null &&
        userEmail != null) {
      _usuario = Usuario(
        id: userId,
        nome: userName,
        email: userEmail,
        token: token,
        profileImageUrl: profileImageUrl,
      );
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _usuario = null;
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'user_id');
    await _storage.delete(key: 'user_name');
    await _storage.delete(key: 'user_email');
    await _storage.delete(key: 'user_profile_image');
    notifyListeners();
  }

  Future<void> updateProfileImage(String imageUrl) async {
    if (_usuario != null) {
      _usuario = Usuario(
        id: _usuario!.id,
        nome: _usuario!.nome,
        email: _usuario!.email,
        token: _usuario!.token,
        profileImageUrl: imageUrl,
      );
      await _storage.write(key: 'user_profile_image', value: imageUrl);
      notifyListeners();
    }
  }
}

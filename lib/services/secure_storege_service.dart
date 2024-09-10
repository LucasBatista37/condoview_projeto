import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> salvarToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<String?> lerToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<void> removerToken() async {
    await _storage.delete(key: 'auth_token');
  }

  writeToken(String token) {}
}

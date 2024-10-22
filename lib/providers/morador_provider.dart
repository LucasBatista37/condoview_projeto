import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MoradorProvider with ChangeNotifier {
  final String _baseUrl = 'https://backend-condoview.onrender.com';

  Future<void> adicionarMorador(
      String email, String telefone, String funcionalidade) async {
    if (email.isEmpty || telefone.isEmpty || funcionalidade.isEmpty) {
      throw Exception('Por favor, preencha todos os campos!');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/admin/associate'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'telefone': telefone,
        'funcionalidade': funcionalidade,
      }),
    );

    if (response.statusCode != 200) {
      final errorResponse = json.decode(response.body);
      throw Exception(errorResponse['errors'][0]);
    }

    notifyListeners(); 
  }
}

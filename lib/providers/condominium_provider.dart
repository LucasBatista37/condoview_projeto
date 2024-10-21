import 'package:condoview/models/condominium_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CondoProvider with ChangeNotifier {
  final String baseUrl = 'http://10.0.1.9:5000';

  Future<void> createCondo(Condominium condo) async {
    final url = Uri.parse(
        '$baseUrl/api/users/create-condominium'); 

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(condo.toJson()),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print('Condomínio ${data['name']} criado com sucesso!');
      } else if (response.statusCode == 422) {
        print('Erro: CNPJ já cadastrado.');
      } else {
        print('Erro ao criar condomínio. Status: ${response.statusCode}');
      }
    } catch (error) {
      print('Erro de conexão: $error');
    }
  }
}

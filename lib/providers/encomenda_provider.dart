import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:condoview/models/encomenda_model.dart';

class EncomendasProvider with ChangeNotifier {
  final String _baseUrl = 'https://backend-condoview.onrender.com';
  List<Encomenda> _encomendas = [];

  List<Encomenda> get encomendas => _encomendas;

  Future<void> addEncomenda(Encomenda encomenda) async {
    final url = Uri.parse('$_baseUrl/api/users/package');

    final requestBody = {
      'title': encomenda.title,
      'apartment': encomenda.apartment,
      'time': DateTime.now().toIso8601String(),
      'imagePath': encomenda.imagePath,
      'status': encomenda.status,
      "email": "novo1@gmail.com"
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 201) {
        print('Encomenda adicionada com sucesso: ${response.body}');
        _encomendas.add(encomenda);
        notifyListeners();
      } else {
        throw Exception('Falha ao adicionar encomenda: ${response.body}');
      }
    } catch (error) {
      print('Erro ao adicionar encomenda: $error');
      throw error;
    }
  }

  Future<void> fetchEncomendas() async {
    final url = Uri.parse('$_baseUrl/api/users/admin/package');

    try {
      final response = await http.get(
        url,
        headers: {
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _encomendas =
            data.map((encomenda) => Encomenda.fromJson(encomenda)).toList();
        notifyListeners();
      } else {
        throw Exception('Falha ao carregar encomendas: ${response.body}');
      }
    } catch (error) {
      print('Erro ao buscar encomendas: $error');
      throw error;
    }
  }
}

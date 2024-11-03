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
    final requestBody = encomenda.toJson();

    print('Request body enviado: $requestBody');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        print('Resposta do backend: $responseData'); 

        final newEncomenda = Encomenda.fromJson(responseData['newPackage']);
        print('Encomenda adicionada com sucesso: ${newEncomenda.id}');
        _encomendas.add(newEncomenda);
        notifyListeners();
      } else {
        print(
            'Falha ao adicionar encomenda. Código: ${response.statusCode}, Resposta: ${response.body}');
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
        headers: {},
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

  Future<void> updateEncomenda(Encomenda encomenda) async {
    final url = Uri.parse('$_baseUrl/api/users/admin/package/${encomenda.id}');

    final requestBody = {
      'title': encomenda.title,
      'apartment': encomenda.apartment,
      'time': encomenda.time,
      'imagePath': encomenda.imagePath,
      'status': encomenda.status,
    };

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        print('Encomenda atualizada com sucesso: ${response.body}');
        int index = _encomendas.indexWhere((e) => e.id == encomenda.id);
        if (index != -1) {
          _encomendas[index] = encomenda;
        }
        notifyListeners();
      } else {
        throw Exception('Falha ao atualizar encomenda: ${response.body}');
      }
    } catch (error) {
      print('Erro ao atualizar encomenda: $error');
      throw error;
    }
  }
}

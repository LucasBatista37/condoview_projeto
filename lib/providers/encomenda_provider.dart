import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:condoview/models/encomenda_model.dart';

class EncomendasProvider with ChangeNotifier {
  final String _baseUrl = 'http://10.0.1.9:5000'; // URL do backend
  List<Encomenda> _encomendas = [];
  final String _token =
      'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3MGM2YTIwOGRlOTY2ODg0ZTQ5NDE2ZiIsImlhdCI6MTcyODg2Njg0OCwiZXhwIjoxNzI5NDcxNjQ4fQ.Y4Mf7L6LJsSE7zAtzN3iFnvTZtm_Fg0NdYsh5EZOGtE'; // Substitua com seu token JWT

  List<Encomenda> get encomendas => [..._encomendas];

  // Método para adicionar uma encomenda
  Future<void> addEncomenda(Encomenda encomenda) async {
    final url = Uri.parse('$_baseUrl/api/users/admin/package');

    try {
      final request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] = _token
        ..fields['title'] = encomenda.title
        ..fields['apartment'] = encomenda.apartment
        ..fields['time'] = encomenda.time
        ..fields['type'] = encomenda.status
        ..files.add(await http.MultipartFile.fromPath(
            'imagePath', encomenda.imagePath));

      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        final decodedData = json.decode(responseData);
        _encomendas.add(Encomenda.fromJson(decodedData['newPackage']));
        notifyListeners();
      } else {
        print('Erro no servidor: $responseData');
        throw Exception(
            'Falha ao adicionar encomenda. Código: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Erro ao adicionar encomenda: $error');
    }
  }

  Future<void> fetchEncomendas() async {
    final url = Uri.parse('$_baseUrl/api/users/package');

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': _token},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        _encomendas = data.map((item) => Encomenda.fromJson(item)).toList();
        notifyListeners();
      } else {
        throw Exception('Erro ao carregar encomendas');
      }
    } catch (error) {
      throw Exception('Erro ao buscar encomendas: $error');
    }
  }
}

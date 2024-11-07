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

    print('Iniciando o envio da encomenda: ${encomenda.toJson()}');

    try {
      var request = http.MultipartRequest('POST', url);

      request.fields['title'] = encomenda.title;
      request.fields['apartment'] = encomenda.apartment;
      request.fields['time'] = encomenda.time;
      request.fields['status'] =
          encomenda.status.isNotEmpty ? encomenda.status : 'Pendente';

      print('Campos adicionados à requisição: ${request.fields}');

      if (encomenda.imagePath.isNotEmpty) {
        print('Anexando imagem do caminho: ${encomenda.imagePath}');
        request.files.add(await http.MultipartFile.fromPath(
          'imagePath',
          encomenda.imagePath,
        ));
      } else {
        print('Nenhuma imagem a ser anexada.');
      }

      var response = await request.send();
      print('Resposta recebida: ${response.statusCode}');

      if (response.statusCode == 201) {
        final responseData = await response.stream.bytesToString();
        print('Resposta do backend: $responseData');

        final newEncomenda =
            Encomenda.fromJson(json.decode(responseData)['newPackage']);
        print('Encomenda adicionada com sucesso: ${newEncomenda.id}');
        _encomendas.add(newEncomenda);
        notifyListeners();
      } else {
        print(
            'Falha ao adicionar encomenda. Código: ${response.statusCode}, Resposta: ${response.reasonPhrase}');
        throw Exception('Erro ao adicionar encomenda');
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

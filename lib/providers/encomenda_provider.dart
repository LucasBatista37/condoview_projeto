import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:condoview/models/encomenda_model.dart';

class EncomendasProvider with ChangeNotifier {
  final String _baseUrl = 'https://backend-condoview.onrender.com';
  List<Encomenda> _encomendas = [];
  Timer? _pollingTimer;
  bool _isLoading = false;

  List<Encomenda> get encomendas => _encomendas;
  bool get isLoading => _isLoading;

  Future<void> addEncomenda(Encomenda encomenda) async {
    final url = Uri.parse('$_baseUrl/api/users/package');

    try {
      var request = http.MultipartRequest('POST', url);

      request.fields['title'] = encomenda.title;
      request.fields['apartment'] = encomenda.apartment;
      request.fields['time'] = encomenda.time;
      request.fields['status'] = encomenda.status;
      request.fields['usuarioId'] = encomenda.usuarioId;
      request.fields['usuarioNome'] = encomenda.usuarioNome;

      debugPrint("Campos enviados na requisição: ${request.fields}");

      if (encomenda.imagePath.isNotEmpty &&
          File(encomenda.imagePath).existsSync()) {
        request.files.add(await http.MultipartFile.fromPath(
          'imagePath',
          encomenda.imagePath,
        ));
        debugPrint("Imagem anexada: ${encomenda.imagePath}");
      } else {
        debugPrint(
            "Arquivo de imagem inválido ou não encontrado: ${encomenda.imagePath}");
      }

      var response = await request.send();

      if (response.statusCode == 201) {
        debugPrint("Encomenda adicionada com sucesso.");
        final responseData = await response.stream.bytesToString();
        final newEncomenda =
            Encomenda.fromJson(json.decode(responseData)['newPackage']);
        _encomendas.add(newEncomenda);
        notifyListeners();
      } else {
        final errorResponse = await response.stream.bytesToString();
        debugPrint("Erro ao adicionar encomenda: $errorResponse");
        throw Exception(
            'Erro ao adicionar encomenda. Código: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint("Erro ao adicionar encomenda: $error");
      throw error;
    }
  }

  void startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      fetchEncomendas();
    });
  }

  void stopPolling() {
    _pollingTimer?.cancel();
  }

  Future<void> fetchEncomendas() async {
    final url = Uri.parse('$_baseUrl/api/users/admin/package');
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        debugPrint("Resposta da API: $data");

        _encomendas = data.map((encomenda) {
          debugPrint("Encomenda recebida: $encomenda");
          return Encomenda.fromJson(encomenda);
        }).toList();
      } else {
        throw Exception('Falha ao carregar encomendas: ${response.body}');
      }
    } catch (error) {
      print('Erro ao buscar encomendas: $error');
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateEncomenda(Encomenda encomenda) async {
    final url = Uri.parse(
        'https://backend-condoview.onrender.com/api/users/admin/package/${encomenda.id}');

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(encomenda.toJson()),
      );

      if (response.statusCode == 200) {
        debugPrint("Encomenda atualizada com sucesso: ${response.body}");

        final updatedEncomenda =
            Encomenda.fromJson(json.decode(response.body)['updatedPackage']);

        final index =
            _encomendas.indexWhere((element) => element.id == encomenda.id);
        if (index != -1) {
          _encomendas[index] = updatedEncomenda;
          notifyListeners();
        }
      } else {
        debugPrint("Erro ao atualizar encomenda: ${response.body}");
        throw Exception("Erro ao atualizar encomenda: ${response.body}");
      }
    } catch (error) {
      debugPrint("Erro ao enviar atualização para o backend: $error");
      rethrow;
    }
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }
}

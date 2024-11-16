import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:condoview/models/ocorrencia_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OcorrenciaProvider with ChangeNotifier {
  List<Ocorrencia> _ocorrencias = [];
  Ocorrencia? _selectedOcorrencia;
  bool _isLoading = false;
  Timer? _pollingTimer;

  List<Ocorrencia> get ocorrencias => _ocorrencias;
  Ocorrencia? get selectedOcorrencia => _selectedOcorrencia;
  bool get isLoading => _isLoading;

  final String _baseUrl = 'https://backend-condoview.onrender.com';

  Future<void> addOcorrencia({
    required String motivo,
    required String descricao,
    required DateTime data,
    File? imagem,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/api/users/ocorrencias');
      final request = http.MultipartRequest('POST', url);

      request.fields['motivo'] = motivo;
      request.fields['descricao'] = descricao;
      request.fields['data'] = data.toIso8601String();

      if (imagem != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'imagem',
          imagem.path,
        ));
      }

      final response = await request.send().timeout(Duration(seconds: 180));

      if (response.statusCode == 201) {
        print('Ocorrência criada com sucesso!');
      } else {
        final responseString = await response.stream.bytesToString();
        print(
            'Erro ao criar ocorrência: ${response.statusCode} - $responseString');
        throw Exception('Falha ao criar ocorrência');
      }
    } catch (error) {
      print('Erro ao enviar a ocorrência: $error');
      throw error;
    }
  }

    Future<void> fetchOcorrencias() async {
    final url = Uri.parse('$_baseUrl/api/users/admin/ocorrencias');
    print('Iniciando a busca de ocorrências...');

    try {
      _isLoading = true;
      notifyListeners();

      final response = await http.get(url).timeout(Duration(seconds: 10));
      print('Requisição feita para: $url');

      if (response.statusCode == 200) {
        print('Requisição bem-sucedida. Status: ${response.statusCode}');
        final data = json.decode(response.body) as List;

        _ocorrencias = data.map((item) {
          return Ocorrencia(
            motivo: item['motivo'],
            descricao: item['descricao'],
            data: DateTime.parse(item['data']),
            image: item['imagemPath'] != null ? File(item['imagemPath']) : null,
          );
        }).toList();

        notifyListeners();
      } else {
        throw Exception(
            'Erro ao buscar ocorrências. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar ocorrências: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      fetchOcorrencias();
    });
  }

  void stopPolling() {
    _pollingTimer?.cancel();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  void selectOcorrencia(Ocorrencia ocorrencia) {
    _selectedOcorrencia = ocorrencia;
    notifyListeners();
  }
}

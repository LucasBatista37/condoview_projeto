import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:condoview/models/aviso_model.dart';

class AvisoProvider with ChangeNotifier {
  final String baseUrl = 'https://backend-condoview.onrender.com';
  List<Aviso> _avisos = [];
  Timer? _pollingTimer;

  List<Aviso> get avisos => _avisos;

  Future<void> addAviso(Aviso aviso) async {
    final url = Uri.parse('$baseUrl/api/users/admin/notices');

    print('Iniciando o método addAviso com o título: ${aviso.title}');

    final requestBody = {
      'title': aviso.title,
      'message': aviso.description,
      'date': DateTime.now().toIso8601String(),
    };

    print('Corpo da requisição: ${json.encode(requestBody)}');

    try {
      print('Enviando solicitação POST para: $url');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      print('Resposta recebida: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 201) {
        print('Aviso adicionado com sucesso: ${response.body}');
      } else {
        throw Exception('Falha ao adicionar aviso: ${response.body}');
      }
    } catch (error) {
      print('Erro ao adicionar aviso: $error');
      throw error;
    }
  }

    void startPolling() {
    _pollingTimer?.cancel(); 
    _pollingTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      fetchAvisos(); 
    });
  }

  void stopPolling() {
    _pollingTimer?.cancel();
  }

   void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> fetchAvisos() async {
    final url = Uri.parse('$baseUrl/api/users/admin/notices');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _avisos = data.map((aviso) => Aviso.fromJson(aviso)).toList();
        notifyListeners();
      } else {
        throw Exception('Falha ao carregar avisos: ${response.body}');
      }
    } catch (error) {
      print('Erro ao buscar avisos: $error');
      throw error;
    }
  }

  Future<void> updateAviso(Aviso aviso) async {
    final url = Uri.parse('$baseUrl/api/users/admin/notices/${aviso.id}');

    final requestBody = {
      'title': aviso.title,
      'message': aviso.description,
      'date': aviso.time,
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
        print('Aviso atualizado com sucesso: ${response.body}');
        final updatedAviso = Aviso.fromJson(json.decode(response.body));
        int index = _avisos.indexWhere((a) => a.id == aviso.id);
        if (index != -1) {
          _avisos[index] = updatedAviso;
          notifyListeners();
        }
      } else {
        throw Exception('Falha ao atualizar aviso: ${response.body}');
      }
    } catch (error) {
      print('Erro ao atualizar aviso: $error');
      throw error;
    }
  }

  Future<void> removeAviso(Aviso aviso) async {
    final url = Uri.parse('$baseUrl/api/users/admin/notices/${aviso.id}');

    try {
      final response = await http.delete(
        url,
      );

      if (response.statusCode == 200) {
        print('Aviso excluído com sucesso: ${response.body}');
        _avisos.removeWhere((a) => a.id == aviso.id);
        notifyListeners();
      } else {
        throw Exception('Falha ao excluir aviso: ${response.body}');
      }
    } catch (error) {
      print('Erro ao excluir aviso: $error');
      throw error;
    }
  }

  Aviso getAvisoById(String id) {
    return _avisos.firstWhere(
      (aviso) => aviso.id == id,
      orElse: () {
        throw Exception('Aviso com ID $id não encontrado');
      },
    );
  }
}

import 'dart:async';
import 'dart:convert';
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
      request.fields['status'] =
          encomenda.status.isNotEmpty ? encomenda.status : 'Pendente';

      if (encomenda.imagePath.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(
          'imagePath',
          encomenda.imagePath,
        ));
      }

      var response = await request.send();

      if (response.statusCode == 201) {
        final responseData = await response.stream.bytesToString();
        final newEncomenda =
            Encomenda.fromJson(json.decode(responseData)['newPackage']);
        _encomendas.add(newEncomenda);
        notifyListeners();
      } else {
        throw Exception('Erro ao adicionar encomenda');
      }
    } catch (error) {
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
    notifyListeners(); // Notifica que o carregamento começou

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _encomendas =
            data.map((encomenda) => Encomenda.fromJson(encomenda)).toList();
      } else {
        throw Exception('Falha ao carregar encomendas: ${response.body}');
      }
    } catch (error) {
      print('Erro ao buscar encomendas: $error');
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners(); // Notifica que o carregamento terminou
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
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
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

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }
}

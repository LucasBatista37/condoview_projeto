import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:condoview/models/manutencao_model.dart';

class ManutencaoProvider with ChangeNotifier {
  final String _baseUrl = 'https://backend-condoview.onrender.com';
  List<Manutencao> _manutencoes = [];
  Timer? _pollingTimer;

  List<Manutencao> get manutencoes => _manutencoes;

  Future<void> adicionarManutencao(Manutencao manutencao) async {
    final url = Uri.parse('$_baseUrl/api/users/maintenance');

    try {
      var request = http.MultipartRequest('POST', url);

      request.fields['type'] = manutencao.tipo;
      request.fields['descriptionMaintenance'] = manutencao.descricao;
      request.fields['dataMaintenance'] = manutencao.data.toIso8601String();
      request.fields['usuarioNome'] = manutencao.usuarioNome; 

      if (manutencao.imagemPath != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'imagePath',
          manutencao.imagemPath!,
        ));
      }

      var response = await request.send();

      if (response.statusCode == 201) {
        notifyListeners();
      } else {
        print('Erro ao solicitar manutenção: ${response.statusCode}');
        throw Exception('Erro ao solicitar manutenção');
      }
    } catch (error) {
      print('Erro ao enviar manutenção: $error');
      throw error;
    }
  }

  Future<void> fetchManutencoes() async {
    final url = Uri.parse('$_baseUrl/api/users/admin/maintenance');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _manutencoes = data.map((item) => Manutencao.fromJson(item)).toList();
        notifyListeners();
      } else {
        throw Exception('Erro ao obter manutenções');
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  void startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      fetchManutencoes();
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

  Future<void> atualizarManutencao(
      Manutencao manutencao, String manutencaoId) async {
    final url = Uri.parse('$_baseUrl/admin/maintenance/$manutencaoId');

    try {
      var request = http.MultipartRequest('PUT', url);

      request.fields['type'] = manutencao.tipo;
      request.fields['descriptionMaintenance'] = manutencao.descricao;
      request.fields['dataMaintenance'] = manutencao.data.toIso8601String();
      request.fields['status'] = manutencao.status;

      if (manutencao.imagemPath != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'imagePath',
          manutencao.imagemPath!,
        ));
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        notifyListeners();
      } else {
        print('Erro ao atualizar manutenção: ${response.statusCode}');
        throw Exception('Erro ao atualizar manutenção');
      }
    } catch (error) {
      print('Erro ao atualizar manutenção: $error');
      throw error;
    }
  }

  Future<void> deletarManutencao(String manutencaoId) async {
    final url = Uri.parse('$_baseUrl/admin/maintenance/$manutencaoId');

    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        notifyListeners();
      } else {
        throw Exception('Erro ao deletar manutenção');
      }
    } catch (error) {
      print('Erro ao deletar manutenção: $error');
      throw error;
    }
  }

  Future<void> aprovarManutencao(String manutencaoId) async {
    final url = Uri.parse(
        '$_baseUrl/api/users/admin/maintenance/approve/$manutencaoId');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final index = _manutencoes.indexWhere((m) => m.id == manutencaoId);
        if (index != -1) {
          _manutencoes[index].status = 'Aprovada';
          _manutencoes[index].statusColor = Colors.green;
        }
        notifyListeners();
      } else {
        print('Erro ao aprovar manutenção: ${response.body}');
        throw Exception('Erro ao aprovar manutenção: ${response.body}');
      }
    } catch (error) {
      print('Erro ao aprovar manutenção: $error');
      throw error;
    }
  }

  Future<void> rejeitarManutencao(String manutencaoId) async {
    final url =
        Uri.parse('$_baseUrl/api/users/admin/maintenance/reject/$manutencaoId');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final index = _manutencoes.indexWhere((m) => m.id == manutencaoId);
        if (index != -1) {
          _manutencoes[index].status = 'Rejeitada';
          _manutencoes[index].statusColor = Colors.red;
        }
        notifyListeners();
      } else {
        print('Erro ao rejeitar manutenção: ${response.body}');
        throw Exception('Erro ao rejeitar manutenção: ${response.body}');
      }
    } catch (error) {
      print('Erro ao rejeitar manutenção: $error');
      throw error;
    }
  }
}

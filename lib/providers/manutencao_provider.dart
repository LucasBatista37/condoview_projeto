import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:condoview/models/manutencao_model.dart';

class ManutencaoProvider with ChangeNotifier {
  final String _baseUrl = 'http://10.0.1.9:5000';
  final String _token =
      'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3MGM2YTIwOGRlOTY2ODg0ZTQ5NDE2ZiIsImlhdCI6MTcyODg2Njg0OCwiZXhwIjoxNzI5NDcxNjQ4fQ.Y4Mf7L6LJsSE7zAtzN3iFnvTZtm_Fg0NdYsh5EZOGtE';
  List<Manutencao> _manutencoes = [];

  List<Manutencao> get manutencoes => _manutencoes;

  Future<void> adicionarManutencao(Manutencao manutencao) async {
    final url = Uri.parse('$_baseUrl/api/users/maintenance');

    try {
      var request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] = _token;

      request.fields['type'] = manutencao.tipo;
      request.fields['descriptionMaintenance'] = manutencao.descricao;
      request.fields['dataMaintenance'] = manutencao.data.toIso8601String();

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
      final response = await http.get(url, headers: {
        'Authorization': _token,
      });
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

  Future<void> atualizarManutencao(
      Manutencao manutencao, String manutencaoId) async {
    final url = Uri.parse('$_baseUrl/admin/maintenance/$manutencaoId');

    try {
      var request = http.MultipartRequest('PUT', url)
        ..headers['Authorization'] = _token;

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
      final response = await http.delete(url, headers: {
        'Authorization': _token,
      });
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
          'Authorization': _token,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        _manutencoes.firstWhere((m) => m.id == manutencaoId).status =
            'aprovado';
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
          'Authorization': _token,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        _manutencoes.firstWhere((m) => m.id == manutencaoId).status =
            'rejeitado';
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

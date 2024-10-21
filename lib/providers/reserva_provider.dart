import 'package:condoview/models/reserva_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReservaProvider with ChangeNotifier {
  List<Reserva> _reservas = [];

  List<Reserva> get reservas => _reservas;

  final String _baseUrl = 'http://10.0.1.9:5000';

  Future<void> adicionarReserva(Reserva reserva) async {
    final url = '$_baseUrl/api/users/reserve';
    print('Dados a serem enviados: ${reserva.toJson()}');
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(reserva.toJson()),
      );
      if (response.statusCode == 201) {
        notifyListeners();
      } else {
        throw Exception('Erro ao criar reserva: ${response.body}');
      }
    } catch (error) {
      print('Erro ao adicionar reserva: $error');
      throw error;
    }
  }

  Future<void> fetchReservas() async {
    final url =
        '$_baseUrl/api/users/reserve'; // Seu endpoint para buscar reservas
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json', // Sem o token de autenticação
        },
      );

      print('Status da resposta: ${response.statusCode}');
      print('Corpo da resposta: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        _reservas = data.map((item) {
          return Reserva(
            id: item['id'] ?? '',
            area: item['area'] ?? '',
            descricao: item['description'] ?? 'Descrição não disponível',
            data: item['data'] != null
                ? DateTime.parse(item['data'])
                : DateTime.now(),
            horarioInicio: _parseTime(item['hourStart'] ?? '00:00'),
            horarioFim: _parseTime(item['hourEnd'] ?? '00:00'),
            status: item['status'] ?? 'Desconhecido',
          );
        }).toList();
        notifyListeners();
      } else {
        throw Exception('Erro ao buscar reservas: ${response.body}');
      }
    } catch (error) {
      print('Erro ao buscar reservas: $error');
      throw error;
    }
  }

  Future<void> aprovarReserva(String id) async {
    final url = '$_baseUrl/api/users/admin/reserve/approve/$id';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        _reservas.firstWhere((reserva) => reserva.id == id).status = "aprovado";
        notifyListeners();
      } else {
        throw Exception('Erro ao aprovar reserva: ${response.body}');
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> rejeitarReserva(String id) async {
    final url = '$_baseUrl/api/users/admin/reserve/reject/$id';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        _reservas.firstWhere((reserva) => reserva.id == id).status =
            "rejeitado";
        notifyListeners();
      } else {
        throw Exception('Erro ao rejeitar reserva: ${response.body}');
      }
    } catch (error) {
      throw error;
    }
  }

  Future<String?> recuperarId(int index) async {
    final reserva = _reservas[index];
    return reserva.id;
  }

  TimeOfDay _parseTime(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}

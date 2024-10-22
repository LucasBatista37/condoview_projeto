import 'package:condoview/models/reserva_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReservaProvider with ChangeNotifier {
  List<Reserva> _reservas = [];

  List<Reserva> get reservas => _reservas;

  final String _baseUrl = 'https://backend-condoview.onrender.com';

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
        final data = json.decode(response.body);

        final novaReserva = Reserva(
          id: data['_id'],
          area: reserva.area,
          descricao: reserva.descricao,
          data: reserva.data,
          horarioInicio: reserva.horarioInicio,
          horarioFim: reserva.horarioFim,
          status: reserva.status,
        );
        _reservas.add(novaReserva);
        notifyListeners();
      } else {
        throw Exception(
            'Erro ao criar reserva: ${response.statusCode} - ${response.body}');
      }
    } catch (error) {
      print('Erro ao adicionar reserva: $error');
      throw error;
    }
  }

  Future<void> fetchReservas() async {
    final url = '$_baseUrl/api/users/admin/reserve';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('Status da resposta: ${response.statusCode}');
      print('Corpo da resposta: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        _reservas = data.map((item) {
          return Reserva(
            id: item['_id'] ?? '',
            area: item['area'] ?? '',
            descricao: item['descricao'] ?? 'Descrição não disponível',
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
        throw Exception(
            'Erro ao buscar reservas: ${response.statusCode} - ${response.body}');
      }
    } catch (error) {
      print('Erro ao buscar reservas: $error');
      throw error;
    }
  }

  Future<void> aprovarReserva(String id) async {
    final url = '$_baseUrl/api/users/admin/reserve/approve/$id';
    try {
      debugPrint('Enviando solicitação para aprovar a reserva com ID: $id');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      debugPrint('Resposta da API: ${response.statusCode}');
      debugPrint('Corpo da resposta: ${response.body}');

      if (response.statusCode == 200) {
        final reserva = _reservas.firstWhere((reserva) => reserva.id == id);
        reserva.status =
            "aprovado"; // Ou outro valor que você use para "aprovado"
        notifyListeners();
      } else {
        // Adicionando mais detalhes ao erro
        final errorMessage =
            response.body; // Supondo que a mensagem de erro esteja aqui
        throw Exception(
            'Erro ao aprovar reserva: ${response.statusCode} - $errorMessage');
      }
    } catch (error) {
      debugPrint('Erro ao aprovar reserva: $error');
      throw error; // Rethrow para que a tela possa tratar o erro
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

      debugPrint('Resposta da API: ${response.statusCode}');
      debugPrint('Corpo da resposta: ${response.body}');

      if (response.statusCode == 200) {
        final reserva = _reservas.firstWhere((reserva) => reserva.id == id);
        reserva.status = "rejeitado";
        notifyListeners();
      } else {
        throw Exception(
            'Erro ao rejeitar reserva: ${response.statusCode} - ${response.body}');
      }
    } catch (error) {
      debugPrint('Erro ao rejeitar reserva: $error');
      throw error;
    }
  }

  Future<String?> recuperarId(int index) async {
    if (index >= 0 && index < _reservas.length) {
      final reserva = _reservas[index];
      return reserva.id;
    }
    return null;
  }

  TimeOfDay _parseTime(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}

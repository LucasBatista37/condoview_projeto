import 'dart:async';

import 'package:condoview/models/reserva_model.dart';
import 'package:condoview/providers/usuario_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class ReservaProvider with ChangeNotifier {
  List<Reserva> _reservas = [];

  List<Reserva> get reservas => _reservas;
  Timer? _pollingTimer;

  final String _baseUrl = 'https://backend-condoview.onrender.com';

  Future<void> adicionarReserva(BuildContext context, Reserva reserva) async {
    final usuarioProvider =
        Provider.of<UsuarioProvider>(context, listen: false);
    final userName = usuarioProvider.userName;
    final url = '$_baseUrl/api/users/reserve';

    print('Dados a serem enviados: ${reserva.toJson()}');
    try {
      final reservaComUsuario = {
        ...reserva.toJson(),
        'usuario': userName,
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(reservaComUsuario),
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
          nomeUsuario: userName,
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

      debugPrint('Status da resposta: ${response.statusCode}');
      debugPrint('Corpo da resposta: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        _reservas = data.map((item) {
          final reserva = Reserva.fromJson(item);
          debugPrint('Reserva carregada: ${reserva.toJson()}');
          return reserva;
        }).toList();
        notifyListeners();
      } else {
        throw Exception(
            'Erro ao buscar reservas: ${response.statusCode} - ${response.body}');
      }
    } catch (error) {
      debugPrint('Erro ao buscar reservas: $error');
      throw error;
    }
  }

  void startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      fetchReservas();
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

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
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
        reserva.status = "Aprovada";
        notifyListeners();
      } else {
        final errorMessage = response.body;
        throw Exception(
            'Erro ao aprovar reserva: ${response.statusCode} - $errorMessage');
      }
    } catch (error) {
      debugPrint('Erro ao aprovar reserva: $error');
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

      debugPrint('Resposta da API: ${response.statusCode}');
      debugPrint('Corpo da resposta: ${response.body}');

      if (response.statusCode == 200) {
        final reserva = _reservas.firstWhere((reserva) => reserva.id == id);
        reserva.status = "Rejeitada";
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
}

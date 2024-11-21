import 'package:flutter/material.dart';

class Reserva {
  final String? id;
  final String area;
  final String descricao;
  final DateTime data;
  final TimeOfDay horarioInicio;
  final TimeOfDay horarioFim;
  String status;
  final String nomeUsuario;
  Reserva({
    this.id,
    required this.area,
    required this.descricao,
    required this.data,
    required this.horarioInicio,
    required this.horarioFim,
    this.status = 'Pendente',
    required this.nomeUsuario,
  });

  Map<String, dynamic> toJson() {
    return {
      'area': area,
      'descricao': descricao,
      'data': data.toIso8601String(),
      'horarioInicio':
          '${horarioInicio.hour.toString().padLeft(2, '0')}:${horarioInicio.minute.toString().padLeft(2, '0')}',
      'horarioFim':
          '${horarioFim.hour.toString().padLeft(2, '0')}:${horarioFim.minute.toString().padLeft(2, '0')}',
      'status': status,
      'nomeUsuario': nomeUsuario,
    };
  }

  factory Reserva.fromJson(Map<String, dynamic> json) {
    return Reserva(
      id: json['_id'],
      area: json['area'] ?? '',
      descricao: json['descricao'] ?? 'Descrição não disponível',
      data:
          json['data'] != null ? DateTime.parse(json['data']) : DateTime.now(),
      horarioInicio: _parseTime(json['horarioInicio'] ?? '00:00'),
      horarioFim: _parseTime(json['horarioFim'] ?? '00:00'),
      status: json['status'] ?? 'Pendente',
      nomeUsuario: json['nomeUsuario'] ?? 'Usuário desconhecido',
    );
  }

  static TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  Color getStatusColor() {
    switch (status.toLowerCase()) {
      case 'aprovada':
        return Colors.green;
      case 'pendente':
        return Colors.orange;
      case 'rejeitada':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

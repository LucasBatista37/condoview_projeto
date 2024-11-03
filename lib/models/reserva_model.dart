import 'package:flutter/material.dart';

class Reserva {
  final String? id;
  final String area;
  final String descricao;
  final DateTime data;
  final TimeOfDay horarioInicio;
  final TimeOfDay horarioFim;
  String status;

  Reserva({
    this.id,
    required this.area,
    required this.descricao,
    required this.data,
    required this.horarioInicio,
    required this.horarioFim,
    this.status = 'Pendente',
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
    };
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

  String get formattedStatus {
    switch (status.toLowerCase()) {
      case 'aprovada':
        return 'Aprovada';
      case 'pendente':
        return 'Pendente';
      case 'rejeitada':
        return 'Rejeitada';
      default:
        return 'Desconhecido';
    }
  }
}

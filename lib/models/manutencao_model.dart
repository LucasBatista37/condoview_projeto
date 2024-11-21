import 'package:flutter/material.dart';

class Manutencao {
  final String? id;
  final String tipo;
  final String descricao;
  final DateTime data;
  final String? imagemPath;
  String status;
  Color statusColor;
  final String usuarioNome;

  Manutencao({
    this.id,
    required this.tipo,
    required this.descricao,
    required this.data,
    this.imagemPath,
    this.status = "Pendente",
    required this.usuarioNome, 
  }) : statusColor = _getStatusColor(status);

  static Color _getStatusColor(String status) {
    switch (status) {
      case 'Aprovada':
        return Colors.green;
      case 'Rejeitada':
        return Colors.red;
      default:
        return Colors.yellow;
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

  factory Manutencao.fromJson(Map<String, dynamic> json) {
    return Manutencao(
      id: json['_id'],
      tipo: json['type'],
      descricao: json['descriptionMaintenance'],
      data: DateTime.parse(json['dataMaintenance']),
      imagemPath: json['imagePath'],
      status: json['status'],
      usuarioNome: json['usuarioNome'] ?? 'Usuário desconhecido', 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': tipo,
      'descriptionMaintenance': descricao,
      'dataMaintenance': data.toIso8601String(),
      'imagePath': imagemPath,
      'status': status,
      'usuarioNome': usuarioNome, 
    };
  }
}

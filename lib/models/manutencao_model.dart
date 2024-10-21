import 'package:flutter/material.dart';

class Manutencao {
  final String? id;
  final String tipo;
  final String descricao;
  final DateTime data;
  final String? imagemPath;
  String status; 
  Color statusColor; 

  Manutencao({
    this.id,
    required this.tipo,
    required this.descricao,
    required this.data,
    this.imagemPath,
    this.status = "pendente",
  }) : statusColor =
            _getStatusColor(status); 

  static Color _getStatusColor(String status) {
    switch (status) {
      case 'aprovado':
        return Colors.green;
      case 'rejeitado':
        return Colors.red;
      default: // 'pendente'
        return Colors.yellow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': tipo,
      'descriptionMaintenance': descricao,
      'dataMaintenance': data.toIso8601String(),
      'imagePath': imagemPath,
      'status': status,
    };
  }

  factory Manutencao.fromJson(Map<String, dynamic> json) {
    return Manutencao(
      id: json['_id'],
      tipo: json['type'],
      descricao: json['descriptionMaintenance'],
      data: DateTime.parse(json['dataMaintenance']),
      imagemPath: json['imagePath'],
      status: json['approvedMaintenance'] == true
          ? 'aprovado'
          : (json['approvedMaintenance'] == false ? 'rejeitado' : 'pendente'),
    );
  }
}

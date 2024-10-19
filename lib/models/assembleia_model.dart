import 'package:flutter/material.dart';

class Assembleia {
  String? id;
  String titulo;
  String assunto;
  DateTime data;
  TimeOfDay horario;
  String status;
  List<Pauta> pautas;

  Assembleia({
    this.id,
    required this.titulo,
    required this.assunto,
    required this.data,
    required this.horario,
    required this.status,
    required this.pautas,
  });

  factory Assembleia.fromJson(Map<String, dynamic> json) {
    return Assembleia(
      id: json['_id'] ?? '',
      titulo: json['title'] ?? 'Sem título', 
      assunto: json['description'] ?? 'Sem descrição', 
      data: DateTime.parse(
          json['date'] ?? DateTime.now().toIso8601String()), 
      horario: json['hour'] != null
          ? _stringToTimeOfDay(json['hour'])
          : TimeOfDay.now(), 
      status: json['status'] ?? 'Indefinido', 
      pautas: (json['pautas'] as List? ?? [])
          .map((pautaJson) => Pauta.fromJson(pautaJson))
          .toList(),  
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': titulo,
      'description': assunto,
      'date': data.toIso8601String(),
      'hour': _timeOfDayToString(horario),
      'status': status,
      'pautas': pautas.map((pauta) => pauta.toJson()).toList(),
    };
  }

  static TimeOfDay _stringToTimeOfDay(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  static String _timeOfDayToString(TimeOfDay time) {
    return time.hour.toString().padLeft(2, '0') +
        ':' +
        time.minute.toString().padLeft(2, '0');
  }
}

class Pauta {
  String tema;
  String descricao;

  Pauta({
    required this.tema,
    required this.descricao,
  });

  factory Pauta.fromJson(Map<String, dynamic> json) {
    return Pauta(
      tema: json['tema'] ?? 'Sem tema', 
      descricao: json['descricao'] ?? 'Sem descrição', 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tema': tema,
      'descricao': descricao,
    };
  }
}

import 'package:flutter/material.dart';

class Assembleia {
  final String id;
  final String titulo;
  final String assunto;
  final String status;
  final DateTime data;
  final TimeOfDay horario;
  final List<Pauta> pautas;
  Assembleia({
    required this.id,
    required this.titulo,
    required this.assunto,
    this.status = 'Pendente',
    required this.data,
    required this.horario,
    this.pautas = const [],
  });
}

class Pauta {
  final String tema;
  final String descricao;

  Pauta({required this.tema, required this.descricao});
}

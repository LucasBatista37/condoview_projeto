import 'package:flutter/material.dart';

class Reserva {
  final String area;
  final String descricao;
  final DateTime data;
  final TimeOfDay horarioInicio;
  final TimeOfDay horarioFim;
  bool aprovado;

  Reserva({
    required this.area,
    required this.descricao,
    required this.data,
    required this.horarioInicio,
    required this.horarioFim,
    this.aprovado = false,
  });

  get reservadoPor => null;
}

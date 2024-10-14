import 'dart:io';

class Ocorrencia {
  final String motivo;
  final String descricao;
  final DateTime data;
  final File? image;

  Ocorrencia({
    required this.motivo,
    required this.descricao,
    required this.data,
    this.image,
  });

  String? get imagemPath => image?.path;
}

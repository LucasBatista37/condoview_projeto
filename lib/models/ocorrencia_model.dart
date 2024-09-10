import 'dart:io';

class Ocorrencia {
  final String motivo;
  final String descricao;
  final DateTime data;
  final File? imagem;

  Ocorrencia({
    required this.motivo,
    required this.descricao,
    required this.data,
    this.imagem,
  });

  String? get imagemPath => imagem?.path;
}

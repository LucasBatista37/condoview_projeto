class Manutencao {
  final String tipo;
  final String descricao;
  final DateTime data;
  final String? imagemPath;
  bool aprovado;

  Manutencao({
    required this.tipo,
    required this.descricao,
    required this.data,
    this.imagemPath,
    this.aprovado = false,
  });

  String get status => aprovado ? 'Aprovada' : 'Pendente';
}

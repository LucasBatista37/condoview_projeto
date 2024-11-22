class Encomenda {
  final String? id;
  final String title;
  final String apartment;
  final String time;
  final String status;
  final String imagePath;
  final String usuarioId;
  final String usuarioNome;

  Encomenda({
    this.id,
    required this.title,
    required this.apartment,
    required this.time,
    required this.status,
    required this.imagePath,
    required this.usuarioId,
    required this.usuarioNome, 
  });

  factory Encomenda.fromJson(Map<String, dynamic> json) {
    return Encomenda(
      id: json['_id'].toString(),
      title: json['title'],
      apartment: json['apartment'],
      time: json['time'],
      status: json['status'] ?? 'Pendente',
      imagePath: json['imagePath'] ?? '',
      usuarioId: json['usuarioId'] ?? '',
      usuarioNome: json['usuarioNome'] ?? '', 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'apartment': apartment,
      'time': time,
      'status': status.isNotEmpty ? status : 'Pendente',
      'imagePath': imagePath,
      'usuarioId': usuarioId,
      'usuarioNome': usuarioNome,
    };
  }
}

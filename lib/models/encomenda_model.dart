class Encomenda {
  final String title;
  final String apartment;
  final String time;
  final String status;
  final String imagePath;

  Encomenda({
    required this.title,
    required this.apartment,
    required this.time,
    required this.status,
    required this.imagePath,
  });

  factory Encomenda.fromJson(Map<String, dynamic> json) {
    return Encomenda(
      title: json['title'],
      apartment: json['apartment'],
      time: json['time'],
      status: json['status'],
      imagePath: json['imagePath'] ?? '',
    );
  }
}

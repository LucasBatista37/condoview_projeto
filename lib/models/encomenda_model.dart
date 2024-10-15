class Encomenda {
  final String title;
  final String apartment;
  final String time;
  final String imagePath;
  final String status;

  Encomenda({
    required this.title,
    required this.apartment,
    required this.time,
    required this.imagePath,
    required this.status,
  });

  factory Encomenda.fromJson(Map<String, dynamic> json) {
    return Encomenda(
      title: json['title'],
      apartment: json['apartment'],
      time: json['time'],
      imagePath: json['imagePath'],
      status: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'apartment': apartment,
      'time': time,
      'imagePath': imagePath,
      'type': status,
    };
  }
}

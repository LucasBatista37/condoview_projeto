import 'package:flutter/material.dart';

class Aviso {
  final String id;
  final IconData icon;
  final String title;
  final String description;
  final String time;
  final String imageUrl;

  Aviso({
    required this.id,
    required this.icon,
    required this.title,
    required this.description,
    required this.time,
    required this.imageUrl,
  });

  factory Aviso.fromJson(Map<String, dynamic> json) {
    return Aviso(
      id: json['_id'],
      icon: Icons.info, 
      title: json['title'],
      description: json['message'],
      time: json['date'], 
      imageUrl: json['imagePath'] ?? '',
    );
  }

  copyWith({required String title, required String description, required IconData icon, required String time}) {}
}


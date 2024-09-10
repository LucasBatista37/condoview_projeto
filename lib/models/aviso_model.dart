import 'package:flutter/material.dart';

class Aviso {
  final String id;
  final String title;
  final String description;
  final String time;
  final IconData icon;
  final String imageUrl;

  Aviso({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.imageUrl,
  });

  Aviso copyWith({
    String? title,
    String? description,
    String? time,
    IconData? icon,
    String? imageUrl,
  }) {
    return Aviso(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
      icon: icon ?? this.icon,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

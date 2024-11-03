import 'package:flutter/material.dart';

class Aviso {
  final String id;
  final IconData icon;
  final String title;
  final String description;
  final String time;

  Aviso({
    required this.id,
    required this.icon,
    required this.title,
    required this.description,
    required this.time,
  });

  factory Aviso.fromJson(Map<String, dynamic> json) {
    return Aviso(
      id: json['_id'].toString(),
      icon: Icons.info,
      title: json['title'],
      description: json['message'],
      time: json['date'],
    );
  }

  Aviso copyWith({
    String? title,
    String? description,
    IconData? icon,
    String? time,
  }) {
    return Aviso(
      id: this.id,
      icon: icon ?? this.icon,
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
    );
  }
}

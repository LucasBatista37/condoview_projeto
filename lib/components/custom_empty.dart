import 'package:flutter/material.dart';

class CustomEmpty extends StatelessWidget {
  const CustomEmpty({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}

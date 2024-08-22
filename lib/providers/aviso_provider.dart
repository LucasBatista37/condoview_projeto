import 'package:flutter/material.dart';
import 'package:condoview/models/aviso_model.dart';

class AvisoProvider with ChangeNotifier {
  final List<Aviso> _avisos = [];

  List<Aviso> get avisos => _avisos;

  void addAviso(Aviso aviso) {
    _avisos.add(aviso);
    notifyListeners();
  }
}

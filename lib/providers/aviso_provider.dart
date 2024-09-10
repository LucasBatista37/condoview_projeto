import 'package:flutter/material.dart';
import 'package:condoview/models/aviso_model.dart';

class AvisoProvider with ChangeNotifier {
  final List<Aviso> _avisos = [];

  List<Aviso> get avisos => _avisos;

  void addAviso(Aviso aviso) {
    _avisos.add(aviso);
    notifyListeners();
  }

  void removeAviso(Aviso aviso) {
    _avisos.remove(aviso);
    notifyListeners();
  }

  Aviso? getAvisoById(String id) {
    try {
      return _avisos.firstWhere((aviso) => aviso.id == id);
    } catch (e) {
      return null;
    }
  }

  void updateAviso(Aviso updatedAviso) {
    final index = _avisos.indexWhere((aviso) => aviso.id == updatedAviso.id);
    if (index != -1) {
      _avisos[index] = updatedAviso;
      notifyListeners();
    }
  }
}

import 'package:condoview/models/encomenda_model.dart';
import 'package:flutter/material.dart';

class EncomendasProvider extends ChangeNotifier {
  final List<Encomenda> _encomendas = [];

  List<Encomenda> get encomendas => _encomendas;

  void addEncomenda(Encomenda encomenda) {
    _encomendas.add(encomenda);
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:condoview/models/manutencao_model.dart';

class ManutencaoProvider extends ChangeNotifier {
  final List<Manutencao> _manutencoes = [];

  List<Manutencao> get manutencoes => _manutencoes;

  void adicionarManutencao(Manutencao manutencao) {
    _manutencoes.add(manutencao);
    notifyListeners();
  }

  void aprovarManutencao(int index) {
    if (index >= 0 && index < _manutencoes.length) {
      _manutencoes[index].aprovado = true;
      notifyListeners();
    }
  }

  void rejeitarManutencao(int index) {
    if (index >= 0 && index < _manutencoes.length) {
      _manutencoes.removeAt(index);
      notifyListeners();
    }
  }
}

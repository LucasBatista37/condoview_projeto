import 'package:flutter/material.dart';
import '../models/assembleia_model.dart';

class AssembleiaProvider with ChangeNotifier {
  final List<Assembleia> _assembleias = [];

  List<Assembleia> get assembleias => _assembleias;

  void adicionarAssembleia(Assembleia assembleia) {
    _assembleias.add(assembleia);
    notifyListeners();
  }
}

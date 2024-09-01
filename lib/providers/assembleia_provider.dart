import 'package:flutter/material.dart';
import '../models/assembleia_model.dart';

class AssembleiaProvider with ChangeNotifier {
  final List<Assembleia> _assembleias = [];

  List<Assembleia> get assembleias => _assembleias;

  void adicionarAssembleia(Assembleia assembleia) {
    _assembleias.add(assembleia);
    notifyListeners();
  }

  void removeAssembleia(Assembleia assembleia) {
    _assembleias.remove(assembleia);
    notifyListeners();
  }

  void updateAssembleia(Assembleia updatedAssembleia) {
    final index = _assembleias.indexWhere((a) => a.id == updatedAssembleia.id);
    if (index != -1) {
      _assembleias[index] = updatedAssembleia;
      notifyListeners();
    }
  }
}

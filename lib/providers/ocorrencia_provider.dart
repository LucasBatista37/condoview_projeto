import 'dart:io';

import 'package:condoview/models/ocorrencia_model.dart';
import 'package:flutter/material.dart';

class OcorrenciaProvider with ChangeNotifier {
  List<Ocorrencia> _ocorrencias = [];
  Ocorrencia? _selectedOcorrencia;

  List<Ocorrencia> get ocorrencias => _ocorrencias;
  Ocorrencia? get selectedOcorrencia => _selectedOcorrencia;

  void addOcorrencia({
    required String motivo,
    required String descricao,
    required DateTime data,
    File? imagem,
  }) {
    _ocorrencias.add(
      Ocorrencia(
        motivo: motivo,
        descricao: descricao,
        data: data,
        imagem: imagem,
      ),
    );
    notifyListeners();
  }

  void selectOcorrencia(Ocorrencia ocorrencia) {
    _selectedOcorrencia = ocorrencia;
    notifyListeners();
  }

  void clearSelectedOcorrencia() {
    _selectedOcorrencia = null;
    notifyListeners();
  }
}

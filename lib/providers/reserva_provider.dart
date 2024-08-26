import 'package:condoview/models/reserva_model.dart';
import 'package:flutter/material.dart';

class ReservaProvider extends ChangeNotifier {
  final List<Reserva> _reservas = [];

  List<Reserva> get reservas => _reservas;

  void adicionarReserva(Reserva reserva) {
    _reservas.add(reserva);
    notifyListeners();
  }

  void aprovarReserva(int index) {
    if (index >= 0 && index < _reservas.length) {
      _reservas[index].aprovado = true;
      notifyListeners();
    }
  }

  void rejeitarReserva(int index) {
    if (index >= 0 && index < _reservas.length) {
      _reservas.removeAt(index);
      notifyListeners();
    }
  }
}

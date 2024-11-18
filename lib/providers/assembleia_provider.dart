import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:condoview/models/assembleia_model.dart';

class AssembleiaProvider with ChangeNotifier {
  final String _baseUrl = 'https://backend-condoview.onrender.com';

  List<Assembleia> _assembleias = [];
  Timer? _pollingTimer;

  List<Assembleia> get assembleia => _assembleias;

  Future<void> adicionarAssembleia(Assembleia assembleia) async {
    final url = Uri.parse('$_baseUrl/api/users/assemblies');

    String status;
    DateTime agora = DateTime.now();

    if (assembleia.data.isAfter(agora)) {
      status = 'pendente';
    } else if (assembleia.data.isBefore(agora)) {
      status = 'encerrada';
    } else {
      status = 'em andamento';
    }

    final requestBody = json.encode({
      'title': assembleia.titulo,
      'description': assembleia.assunto,
      'date': assembleia.data.toIso8601String(),
      'hourario': formatTimeOfDay(assembleia.horario),
      'imagePath': null,
      'status': status,
      'pautas': assembleia.pautas
          .map((p) => {
                'tema': p.tema,
                'descricao': p.descricao,
              })
          .toList(),
    });

    try {
      print('Enviando dados: $requestBody');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: requestBody,
      );

      if (response.statusCode == 201) {
        notifyListeners();
      } else {
        print('Erro ao criar assembleia. Código: ${response.statusCode}');
        print('Resposta: ${response.body}');
        throw Exception(
            'Falha ao criar a assembleia. Verifique os dados enviados.');
      }
    } catch (error) {
      print('Erro: $error');
      throw error;
    }
  }

    Future<void> fetchAssembleias() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/users/admin/assemblies'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _assembleias = data.map((item) => Assembleia.fromJson(item)).toList();
        notifyListeners();
      } else {
        print('Erro ao carregar assembleias: ${response.statusCode}');
      }
    } catch (error) {
      print('Erro ao buscar assembleias: $error');
    }
  }

    void startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      fetchAssembleias();
    });
  }

  void stopPolling() {
    _pollingTimer?.cancel();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> updateAssembleia(Assembleia assembleia) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/api/users/admin/assemblies/${assembleia.id}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(assembleia.toJson()),
      );

      if (response.statusCode == 200) {
        int index = _assembleias.indexWhere((a) => a.id == assembleia.id);
        if (index != -1) {
          _assembleias[index] = assembleia;
          notifyListeners();
        }
      } else {
        throw Exception('Falha ao atualizar assembleia: ${response.body}');
      }
    } catch (error) {
      print('Erro ao atualizar assembleia: $error');
    }
  }

  Future<void> removeAssembleia(Assembleia assembleia) async {
    final url = '$_baseUrl/api/users/admin/assemblies/${assembleia.id}';

    try {
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200) {
        _assembleias.removeWhere((a) => a.id == assembleia.id);
        notifyListeners();
      } else {
        throw Exception('Erro ao deletar a assembleia: ${response.body}');
      }
    } catch (error) {
      throw Exception('Erro ao deletar a assembleia: $error');
    }
  }

  String formatTimeOfDay(TimeOfDay time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }
}

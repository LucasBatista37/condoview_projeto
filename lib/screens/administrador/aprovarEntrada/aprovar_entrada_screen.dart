import 'package:condoview/screens/morador/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ResultadoQRCodeScreen extends StatelessWidget {
  final String data;
  final String hora;

  ResultadoQRCodeScreen({required this.data, required this.hora});

  @override
  Widget build(BuildContext context) {
    final DateFormat formatador = DateFormat("dd/MM/yyyy HH:mm");
    final DateTime dataHoraQR = formatador.parse("$data $hora");
    final DateTime agora = DateTime.now();

    final bool isAprovado = agora.isBefore(dataHoraQR.add(Duration(hours: 24)));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 78, 20, 166),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Resultado do QR Code',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                isAprovado ? Icons.check_circle : Icons.cancel,
                color: isAprovado ? Colors.green : Colors.red,
                size: 100,
              ),
              const SizedBox(height: 30),
              Text(
                isAprovado ? "Aprovado" : "Reprovado",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: isAprovado ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                isAprovado
                    ? "O QR code está válido dentro das 24 horas."
                    : "O QR code está fora do período de validade.",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 78, 20, 166),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  "Voltar",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:condoview/screens/administrador/aprovarEntrada/aprovar_entrada_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeScannerScreen extends StatefulWidget {
  @override
  _QRCodeScannerScreenState createState() => _QRCodeScannerScreenState();
}

class _QRCodeScannerScreenState extends State<QRCodeScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void dispose() {
    print("Disposing QRViewController");
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          'Escanear QR Code',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    print("QRView created");
    this.controller = controller;

    controller.scannedDataStream.listen((scanData) {
      print("QR code scanned: ${scanData.code}");
      if (scanData.code != null) {
        // ignore: use_build_context_synchronously
        verificarQRCode(context, scanData.code!);
      } else {
        print("QR code is null");
      }
    });
  }

  void verificarQRCode(BuildContext context, String qrData) {
    print("Verificando QR code data: $qrData");
    try {
      final Map<String, dynamic> dados = jsonDecode(qrData);
      print("QR code data decoded successfully: $dados");

      final String data = dados['data'];
      final String hora = dados['hora'];

      print("Data: $data, Hora: $hora");

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultadoQRCodeScreen(data: data, hora: hora),
        ),
      );
    } catch (e, stackTrace) {
      print("Erro ao decodificar QR Code: $e");
      print("Stack trace: $stackTrace");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao decodificar QR Code: $e")),
      );
    }
  }
}

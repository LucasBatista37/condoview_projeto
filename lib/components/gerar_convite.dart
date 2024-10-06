import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:qr_flutter/qr_flutter.dart'; // QR Code package

class GerarConvite extends StatefulWidget {
  final String data; // Data do evento
  final String hora; // Hora do evento
  final String nome; // Nome do visitante
  final String unidade; // Unidade do visitante
  final String condominio; // Nome do condomínio
  final String endereco; // Endereço do condomínio
  final String anfitriao; // Nome do anfitrião

  const GerarConvite({
    super.key,
    required this.data,
    required this.hora,
    required this.nome,
    required this.unidade,
    required this.condominio,
    required this.endereco,
    required this.anfitriao,
  });

  @override
  State<GerarConvite> createState() => _GerarConviteState();
}

class _GerarConviteState extends State<GerarConvite> {
  Future<String> _generateInvitationImage() async {
    try {
      print('Loading image card_template.png');

      final ByteData imageData =
          await rootBundle.load('assets/images/card_template.png');
      final Uint8List bytes = imageData.buffer.asUint8List();

      print('Image loaded successfully');

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, 1004, 591));

      final ui.Image image = await decodeImageFromList(bytes);
      canvas.drawImage(image, Offset.zero, Paint());

      const textStyle = TextStyle(
        color: Colors.black,
        fontSize: 18,
        shadows: [Shadow(offset: Offset(1, 1), color: Colors.black26)],
      );

      // Adicionando informações do convite à imagem (exclua se não precisar)
      final nameTextPainter = TextPainter(
        text: TextSpan(text: '${widget.nome}', style: textStyle),
        textDirection: TextDirection.ltr,
      );
      nameTextPainter.layout();
      nameTextPainter.paint(canvas, const Offset(125, 113));

      final unitTextPainter = TextPainter(
        text: TextSpan(text: '${widget.unidade}', style: textStyle),
        textDirection: TextDirection.ltr,
      );
      unitTextPainter.layout();
      unitTextPainter.paint(canvas, const Offset(201, 324));

      final dateTextPainter = TextPainter(
        text: TextSpan(text: '${widget.data}', style: textStyle),
        textDirection: TextDirection.ltr,
      );
      dateTextPainter.layout();
      dateTextPainter.paint(canvas, const Offset(164, 515));

      final timeTextPainter = TextPainter(
        text: TextSpan(text: '${widget.hora}', style: textStyle),
        textDirection: TextDirection.ltr,
      );
      timeTextPainter.layout();
      timeTextPainter.paint(canvas, const Offset(166, 454));

      final condoTextPainter = TextPainter(
        text: TextSpan(text: '${widget.condominio}', style: textStyle),
        textDirection: TextDirection.ltr,
      );
      condoTextPainter.layout();
      condoTextPainter.paint(canvas, const Offset(239, 195));

      final addressTextPainter = TextPainter(
        text: TextSpan(text: '${widget.endereco}', style: textStyle),
        textDirection: TextDirection.ltr,
      );
      addressTextPainter.layout();
      addressTextPainter.paint(canvas, const Offset(211, 260));

      final hostTextPainter = TextPainter(
        text: TextSpan(text: '${widget.anfitriao}', style: textStyle),
        textDirection: TextDirection.ltr,
      );
      hostTextPainter.layout();
      hostTextPainter.paint(canvas, const Offset(200, 385));

      // Gerando o QR Code
      final qrCodeData =
          '${widget.data},${widget.hora},${widget.nome},${widget.unidade},${widget.condominio},${widget.endereco},${widget.anfitriao}';
      final qrValidationResult = QrValidator.validate(
        data: qrCodeData,
        version: QrVersions.auto,
        errorCorrectionLevel: QrErrorCorrectLevel.L,
      );

      if (qrValidationResult.status == QrValidationStatus.valid) {
        final qrCode = qrValidationResult.qrCode!;
        final qrPainter = QrPainter.withQr(
          qr: qrCode,
          color: const Color(0xFF000000),
          emptyColor: const Color(0xFFFFFFFF),
        );

        final uiImage = await qrPainter.toImage(290);
        canvas.drawImage(uiImage, const Offset(667, 145), Paint());
      }

      final picture = recorder.endRecording();
      final img = await picture.toImage(1004, 591);
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      final buffer = byteData!.buffer.asUint8List();

      print('Image generated successfully');

      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/invitation_image.png');
      await file.writeAsBytes(buffer);

      print('Image saved at path: ${file.path}');

      return file.path;
    } catch (e) {
      print('Error generating the image: $e');
      rethrow;
    }
  }

  bool isConviteValido() {
    DateTime agora = DateTime.now();
    DateTime dataConvite = DateTime.parse('${widget.data} ${widget.hora}');
    Duration diferenca = agora.difference(dataConvite);

    // Retorna true se o convite for válido (menos de 24 horas)
    return diferenca.inHours < 24;
  }

  // Função para compartilhar a imagem
  void _shareInvitation() async {
    try {
      final imagePath = await _generateInvitationImage();
      await Share.shareXFiles(
        [XFile(imagePath)],
        text: 'Aqui está o seu convite de visitante.',
      );

      // Após compartilhar, verificamos a validade e mostramos a imagem correspondente
      bool valido = isConviteValido();
      String resultadoImage = valido
          ? 'assets/images/valid.png' // Imagem para convite válido
          : 'assets/images/invalid.png'; // Imagem para convite inválido

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Image.asset(resultadoImage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Fechar'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error sharing the invitation: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _shareInvitation,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 78, 20, 166),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14.0),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.share, color: Colors.white),
          SizedBox(width: 10),
          Text(
            'Compartilhar Convite',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

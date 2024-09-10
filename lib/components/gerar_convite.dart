import 'dart:io';

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class GerarConvite extends StatefulWidget {
  final String data;
  final String hora;
  final String nome;
  final String unidade;

  const GerarConvite({
    super.key,
    required this.data,
    required this.hora,
    required this.nome,
    required this.unidade,
  });

  @override
  State<GerarConvite> createState() => _GerarConviteState();
}

class _GerarConviteState extends State<GerarConvite> {
  final TextEditingController _dataController = TextEditingController();

  final TextEditingController _horaController = TextEditingController();

  final TextEditingController _nomeController = TextEditingController();

  final TextEditingController _unidadeController = TextEditingController();

  @override
  void dispose() {
    _dataController.dispose();
    _horaController.dispose();
    _nomeController.dispose();
    _unidadeController.dispose();
    super.dispose();
  }

  Future<String> _generateInvitationImage() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromPoints(const Offset(0, 0), const Offset(500, 250)),
    );

    final paintBackground = Paint()
      ..shader = ui.Gradient.linear(
        const Offset(0, 0),
        const Offset(500, 250),
        [
          const ui.Color.fromARGB(255, 89, 41, 177),
          const ui.Color.fromARGB(255, 89, 41, 177),
        ],
      )
      ..style = PaintingStyle.fill;
    canvas.drawRect(const Rect.fromLTWH(0, 0, 500, 250), paintBackground);

    final titlePainter = TextPainter(
      text: const TextSpan(
        text: 'CONVITE DE VISITANTE',
        style: TextStyle(
          color: Colors.white,
          fontSize: 26,
          fontWeight: FontWeight.bold,
          shadows: [Shadow(offset: Offset(2, 2), color: Colors.black38)],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    titlePainter.layout(maxWidth: 450);
    titlePainter.paint(canvas, const Offset(25, 30));

    const iconSize = 20.0;
    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
      shadows: [Shadow(offset: Offset(1, 1), color: Colors.black26)],
    );

    final dateIconPainter = TextPainter(
      text: const TextSpan(
        text: '📅 ',
        style: TextStyle(fontSize: iconSize),
      ),
      textDirection: TextDirection.ltr,
    );
    dateIconPainter.layout();
    dateIconPainter.paint(canvas, const Offset(30, 100));

    final dateTextPainter = TextPainter(
      text: TextSpan(
        text: 'Data: ${widget.data}',
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
    );
    dateTextPainter.layout();
    dateTextPainter.paint(canvas, const Offset(55, 100));

    final timeIconPainter = TextPainter(
      text: const TextSpan(
        text: '⏰ ',
        style: TextStyle(fontSize: iconSize),
      ),
      textDirection: TextDirection.ltr,
    );
    timeIconPainter.layout();
    timeIconPainter.paint(canvas, const Offset(30, 130));

    final timeTextPainter = TextPainter(
      text: TextSpan(
        text: 'Hora: ${widget.hora}',
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
    );
    timeTextPainter.layout();
    timeTextPainter.paint(canvas, const Offset(55, 130));

    final nameIconPainter = TextPainter(
      text: const TextSpan(
        text: '👤 ',
        style: TextStyle(fontSize: iconSize),
      ),
      textDirection: TextDirection.ltr,
    );
    nameIconPainter.layout();
    nameIconPainter.paint(canvas, const Offset(30, 160));

    final nameTextPainter = TextPainter(
      text: TextSpan(
        text: 'Nome: ${widget.nome}',
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
    );
    nameTextPainter.layout();
    nameTextPainter.paint(canvas, const Offset(55, 160));

    final unitIconPainter = TextPainter(
      text: const TextSpan(
        text: '🏠 ',
        style: TextStyle(fontSize: iconSize),
      ),
      textDirection: TextDirection.ltr,
    );
    unitIconPainter.layout();
    unitIconPainter.paint(canvas, const Offset(30, 190));

    final unitTextPainter = TextPainter(
      text: TextSpan(
        text: 'Unidade: ${widget.unidade}',
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
    );
    unitTextPainter.layout();
    unitTextPainter.paint(canvas, const Offset(55, 190));

    final picture = recorder.endRecording();
    final img = await picture.toImage(500, 250);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final buffer = byteData!.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/invitation_image.png');
    await file.writeAsBytes(buffer);

    return file.path;
  }

  void _compartilharConvite() async {
    final imagePath = await _generateInvitationImage();
    await Share.shareXFiles(
      [XFile(imagePath)],
      text: 'Aqui está o convite para o visitante',
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _compartilharConvite,
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

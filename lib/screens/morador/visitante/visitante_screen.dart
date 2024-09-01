import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:share_plus/share_plus.dart';

class VisitanteScreen extends StatefulWidget {
  const VisitanteScreen({super.key});

  @override
  _VisitanteScreenState createState() => _VisitanteScreenState();
}

class _VisitanteScreenState extends State<VisitanteScreen> {
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
        Offset(0, 0),
        Offset(500, 250),
        [
          ui.Color.fromARGB(255, 89, 41, 177),
          ui.Color.fromARGB(255, 89, 41, 177),
        ],
      )
      ..style = PaintingStyle.fill;
    canvas.drawRect(const Rect.fromLTWH(0, 0, 500, 250), paintBackground);

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4);

    final titlePainter = TextPainter(
      text: TextSpan(
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

    final iconSize = 20.0;
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
      shadows: [Shadow(offset: Offset(1, 1), color: Colors.black26)],
    );

    final dateIconPainter = TextPainter(
      text: TextSpan(
        text: '📅 ',
        style: TextStyle(fontSize: iconSize),
      ),
      textDirection: TextDirection.ltr,
    );
    dateIconPainter.layout();
    dateIconPainter.paint(canvas, const Offset(30, 100));

    final dateTextPainter = TextPainter(
      text: TextSpan(
        text: 'Data: ${_dataController.text}',
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
    );
    dateTextPainter.layout();
    dateTextPainter.paint(canvas, const Offset(55, 100));

    final timeIconPainter = TextPainter(
      text: TextSpan(
        text: '⏰ ',
        style: TextStyle(fontSize: iconSize),
      ),
      textDirection: TextDirection.ltr,
    );
    timeIconPainter.layout();
    timeIconPainter.paint(canvas, const Offset(30, 130));

    final timeTextPainter = TextPainter(
      text: TextSpan(
        text: 'Hora: ${_horaController.text}',
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
    );
    timeTextPainter.layout();
    timeTextPainter.paint(canvas, const Offset(55, 130));

    final nameIconPainter = TextPainter(
      text: TextSpan(
        text: '👤 ',
        style: TextStyle(fontSize: iconSize),
      ),
      textDirection: TextDirection.ltr,
    );
    nameIconPainter.layout();
    nameIconPainter.paint(canvas, const Offset(30, 160));

    final nameTextPainter = TextPainter(
      text: TextSpan(
        text: 'Nome: ${_nomeController.text}',
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
    );
    nameTextPainter.layout();
    nameTextPainter.paint(canvas, const Offset(55, 160));

    final unitIconPainter = TextPainter(
      text: TextSpan(
        text: '🏠 ',
        style: TextStyle(fontSize: iconSize),
      ),
      textDirection: TextDirection.ltr,
    );
    unitIconPainter.layout();
    unitIconPainter.paint(canvas, const Offset(30, 190));

    final unitTextPainter = TextPainter(
      text: TextSpan(
        text: 'Unidade: ${_unidadeController.text}',
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      setState(() {
        _dataController.text =
            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        _horaController.text = selectedTime.format(context);
      });
    }
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
          'Visitante',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Insira os dados e compartilhe este convite\ncom o visitante para que ele possa ter a\nentrada liberada',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dados do convite',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _dataController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today),
                        labelText: 'Data',
                        suffixIcon: Icon(Icons.arrow_drop_down),
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _horaController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.access_time),
                        labelText: 'Hora',
                        suffixIcon: Icon(Icons.arrow_drop_down),
                      ),
                      readOnly: true,
                      onTap: () => _selectTime(context),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _nomeController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        labelText: 'Nome do Visitante',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _unidadeController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.home),
                        labelText: 'Unidade',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _compartilharConvite,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 78, 20, 166),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

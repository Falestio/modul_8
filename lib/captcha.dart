import 'dart:math';
import 'package:flutter/material.dart';

class Captcha extends StatefulWidget {
  double lebar, tinggi;
  int jumlahTitikMaks = 10;

  var stokWarna = {
    'merah': Color(0xa9ec1c1c),
    'hijau': Color(0xa922b900),
    'hitam': Color(0xa9000000),
  };
  var warnaTerpakai = {};
  String warnaYangDitanyakan = 'merah';

  Captcha(this.lebar, this.tinggi);

  @override
  State<StatefulWidget> createState() => _CaptchaState();

  bool benarkahJawaban(jawaban) {
    return false;
  }
}

class _CaptchaState extends State<Captcha> {
  var random = Random();
  TextEditingController answerController = TextEditingController(); // Add this line
  bool isAnswerCorrect = false; // Add this line to track answer status

  @override
  void initState() {
    super.initState();
    buatPertanyaan();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: widget.lebar,
            height: widget.tinggi,
            child: CustomPaint(
              painter: CaptchaPainter(widget, isAnswerCorrect), // Modify this line
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Berapa jumlah titik warna ${widget.warnaYangDitanyakan}?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, height: 2),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: answerController,
              enabled: !isAnswerCorrect, // Disable if answer is correct
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Jawaban Anda',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: isAnswerCorrect ? null : periksaJawaban, // Disable if answer is correct
            child: Text('Periksa Jawaban'),
          ),
        ],
      ),
    );
  }

  void periksaJawaban() {
    int userAnswer = int.tryParse(answerController.text) ?? 0;
    if (userAnswer == widget.warnaTerpakai[widget.warnaYangDitanyakan]) {
      setState(() {
        isAnswerCorrect = true;
      });
    } else {
      setState(() {
        isAnswerCorrect = false;
        buatPertanyaan();
      });
    }
  }

  void buatPertanyaan() {
    setState(() {
      widget.warnaYangDitanyakan = widget.stokWarna.keys.elementAt(random.nextInt(3));
    });
  }
}

class CaptchaPainter extends CustomPainter {
  Captcha captcha;
  bool isAnswerCorrect;
  var random = Random();

  CaptchaPainter(this.captcha, this.isAnswerCorrect);

  @override
  void paint(Canvas canvas, Size size) {
    // Existing painting logic...

    if (isAnswerCorrect) {
      // Draw "BENAR" text on the canvas
      var textPainter = TextPainter(
        text: TextSpan(
          text: 'BENAR',
          style: TextStyle(color: Colors.green, fontSize: 30),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(captcha.lebar / 2 - textPainter.width / 2, captcha.tinggi / 2 - textPainter.height / 2));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true; // Change to true
}
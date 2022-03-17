import 'package:flutter/material.dart';
import 'package:icebreaking_app/src/styles/styles.dart';

class CustomRegistro extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    // final gradient  = MyStyles().gradientDiagonal
;

    // final rect = Rect.fromCircle(center: const Offset(0.0, 180.0), radius: 150);

    final paint = Paint()
    ..strokeWidth = 5
    ..style = PaintingStyle.fill
    ..color = MyStyles().colorNaranja
    // ..shader = gradient.createShader(rect)
    ;

    final path = Path();
                           
    path.moveTo(0, 0);

    path.lineTo(0, size.height);
    path.quadraticBezierTo(size.width * 0.2 , size.height * 0.8 , size.width * 0.5 , size.height * 0.9);
    path.quadraticBezierTo(size.width * 0.8 , size.height , size.width , size.height * 0.8);
    path.lineTo(size.width, 0.0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }


}
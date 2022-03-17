import 'package:flutter/material.dart';
import 'package:icebreaking_app/src/styles/styles.dart';

class CustomSettings extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    final Rect rect = Rect.fromCircle(center: const Offset(320, 50), radius: 150);

    final paint = Paint()
      ..strokeWidth = 5
      ..style = PaintingStyle.fill
      ..shader = MyStyles().gradientDiagonal.createShader(rect);

    final path = Path()..moveTo(0,0);

    path.lineTo(0.0, size.height * 0.4);
    path.lineTo(size.width , size.height);
    path.lineTo(size.width, 0.0);

    canvas.drawPath(path, paint);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }





}
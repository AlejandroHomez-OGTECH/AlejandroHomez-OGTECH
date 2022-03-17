import 'package:flutter/material.dart';
import 'package:icebreaking_app/src/styles/styles.dart';

class CustomIceBreakingMode extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    // final Rect rect = Rect.fromCircle(center: const Offset(180, 0) , radius: 180);

    final paint = Paint()
      ..color = MyStyles().colorNaranja
      ..strokeWidth = 5
      ..style = PaintingStyle.fill;
      // ..shader =  MyStyles().gradientHorizontal.createShader(rect);

    final path = Path()..moveTo(0, size.height * 0.65);

    path.quadraticBezierTo(size.width * 0.6, size.height * 0.66, size.width * 0.72, size.height * 0.28);
    path.arcToPoint(Offset(size.width * 0.95, size.height * 0.6), radius: const Radius.circular(20), clockwise: true);
    path.quadraticBezierTo(size.width * 0.91, size.height * 0.7,  size.width, size.height);
    // path.quadraticBezierTo(size.width * 0.92, size.height * 0.3,  size.width, size.height * 0.35);
    path.lineTo(size.width, 0);
    path.lineTo(0,0);
    // canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}


class CustomIceBreakingModeIglus extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    // final Rect rect = Rect.fromCircle(center: const Offset(180, 0) , radius: 180);

    final paint = Paint()
      ..color = MyStyles().colorNaranja
      ..strokeWidth = 5
      ..style = PaintingStyle.fill;
      // ..shader =  MyStyles().gradientHorizontal.createShader(rect);1

    final path = Path()..moveTo(0, size.height * 0.7);

    path.lineTo(size.width * 0.5, size.height);
    path.lineTo(size.width, size.height * 0.7 );
    path.lineTo(size.width, 0);
    path.lineTo(0 , 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

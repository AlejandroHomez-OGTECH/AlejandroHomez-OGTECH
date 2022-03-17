import 'dart:math';

import 'package:flutter/material.dart';
import 'package:icebreaking_app/src/styles/styles.dart';


//Login Custom

class CustomLineLogo1 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    final paintArc1 = Paint()
    ..color = MyStyles().colorRojo
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke;

    final radio = min(size.width * 0.37, size.height * 0.37);
    double arcAngle = 2 * pi * (0.35);
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width * 0.5, size.height * 0.5), radius: radio), 
      -pi / 1.3, 
      arcAngle, 
      false, 
      paintArc1);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
 
}

class CustomLineLogo2 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintArc1 = Paint()
      ..color = MyStyles().colorAzul
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    final radio = min(size.width * 0.41, size.height * 0.41);
    double arcAngle = 2 * pi * (0.35);
    canvas.drawArc(
        Rect.fromCircle(
            center: Offset(size.width * 0.5, size.height * 0.5), radius: radio),
        -pi / 5,
        arcAngle,
        false,
        paintArc1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CustomLineLogo3 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    final Rect rect = Rect.fromCircle(center: const Offset(0, 100), radius: 180);
    
    final Gradient gradient =  MyStyles().gradientVertical;

    final paintArc1 = Paint()
      ..strokeWidth = 15
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ;

    final radio = min(size.width * 0.5, size.height * 0.5);
    double arcAngle = 2 * pi * (0.6);
    canvas.drawArc(
        Rect.fromCircle(
            center: Offset(size.width * 0.5, size.height * 0.5), radius: radio),
        -pi / 1.65,
        arcAngle,
        false,
        paintArc1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}






//Photo Profile Custom


class CustomLineProfile1 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    final paintArc1 = Paint()
    ..color = MyStyles().colorRojo
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 0.5
    ..style = PaintingStyle.stroke;

    final radio = min(size.width * 0.37, size.height * 0.37);
    double arcAngle = 2 * pi * (0.35);
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width * 0.5, size.height * 0.5), radius: radio), 
      -pi / 1.3, 
      arcAngle, 
      false, 
      paintArc1);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
 
}

class CustomLineProfile2 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintArc1 = Paint()
      ..color = MyStyles().colorAzul
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final radio = min(size.width * 0.41, size.height * 0.41);
    double arcAngle = 2 * pi * (0.35);
    canvas.drawArc(
        Rect.fromCircle(center: Offset(size.width * 0.5, size.height * 0.5), radius: radio),
        -pi / 5,
        arcAngle,
        false,
        paintArc1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CustomLineProfile3 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    final Rect rect = Rect.fromCircle(center: const Offset(0, 35), radius: 30);
    
    final Gradient gradient =  MyStyles().gradientVertical;

    final paintArc1 = Paint()
      ..strokeWidth = 5
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ;

    final radio = min(size.width * 0.5, size.height * 0.5);
    double arcAngle = 2 * pi * (0.6);
    canvas.drawArc(
        Rect.fromCircle(
            center: Offset(size.width * 0.5, size.height * 0.5), radius: radio),
        -pi / 1.65,
        arcAngle,
        false,
        paintArc1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}





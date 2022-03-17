import 'package:flutter/material.dart';
import 'package:icebreaking_app/src/styles/styles.dart';

class CustomNavBar extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    final Rect rect = Rect.fromCircle(center: const Offset(180, 0) , radius: 180);

    final paint = Paint()
      ..color = MyStyles().colorRojo
      ..strokeWidth = 5
      ..style = PaintingStyle.fill
      ..shader =  MyStyles().gradientHorizontal.createShader(rect);
    final path = Path()..moveTo(0, 30);

    path.quadraticBezierTo(size.width * 0.20, 15, size.width * 0.30, 7);
    path.quadraticBezierTo(size.width * 0.38, 0, size.width * 0.39, 12);

    path.arcToPoint(Offset(size.width * 0.61, 10.5), radius: const Radius.circular(10), clockwise: false);

    path.quadraticBezierTo(size.width * 0.62, 0, size.width * 0.67, 3);
    path.quadraticBezierTo(size.width * 0.80, 15, size.width, 30);


    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}


class CustomNavBarIceBreaking extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect =
        Rect.fromCircle(center: const Offset(180, 0), radius: 180);

    final paint = Paint()
      ..color = MyStyles().colorRojo
      ..strokeWidth = 5
      ..style = PaintingStyle.fill
      ..shader = MyStyles().gradientHorizontal.createShader(rect);
    final path = Path()..moveTo(0, size.height * 0.3);

    path.quadraticBezierTo(size.width * 0.5, 0, size.width, size.height * 0.3);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}


class CustomNavBarChat extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect =
        Rect.fromCircle(center: const Offset(180, 0), radius: 180);

    final LinearGradient gradient = LinearGradient(
      stops: [ 0.4 , 0.6],
      colors: [
          MyStyles().colorAzul,
          MyStyles().colorRojo
    ]);

    final paint = Paint()
      ..color = MyStyles().colorRojo
      ..strokeWidth = 5
      ..style = PaintingStyle.fill
      ..shader = gradient.createShader(rect);
      
    final path = Path()..moveTo(0, size.height * 0.3);

    path.quadraticBezierTo(size.width * 0.5, 0, size.width, size.height * 0.3);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

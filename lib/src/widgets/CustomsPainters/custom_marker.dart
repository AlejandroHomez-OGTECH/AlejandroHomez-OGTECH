

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icebreaking_app/src/styles/styles.dart';

class CustomMarker extends CustomPainter {

  final String name;
  final String type;

  CustomMarker({
    required this.name,
    required this.type,
  });

  @override
  void paint(Canvas canvas, Size size) {


    final paint2 = Paint()
      ..strokeWidth = 5
      ..style = PaintingStyle.fill
      ..color = Colors.white;



    //Maracador

    final Rect rect = Rect.fromCircle(center: const Offset(100, 85), radius: 20);

    final paint = Paint()
      ..strokeWidth = 5
      ..style = PaintingStyle.fill
      ..shader = MyStyles().gradientDiagonal.createShader(rect);

    final path = Path()
    ..moveTo(0, size.height * 0.75);

    path.arcToPoint(Offset(size.width * 0.18, size.height  * 0.75), radius: const Radius.circular(15), clockwise: true);
    path.quadraticBezierTo(size.width * 0.18, size.height * 0.85,  size.width * 0.09, size.height);
    path.quadraticBezierTo(size.width * 0.0, size.height * 0.85,  0, size.height * 0.75);

    canvas.drawPath(path, paint);


  //Cuadrado
    final pathCuadro = Path()
    ..moveTo(size.width * 0.3, size.height * 0.7);

    pathCuadro.arcToPoint(Offset(size.width * 0.35, 0), radius:const Radius.circular(10), clockwise: true );
    pathCuadro.lineTo(size.width * 0.78, 0);
    pathCuadro.arcToPoint(Offset(size.width * 0.78, size.height * 0.7), radius:const Radius.circular(10), clockwise: true );

    canvas.drawShadow(pathCuadro, Colors.black, 5, false);
    canvas.drawPath(pathCuadro, paint2);

    //CirculoBlanco

        final paintCircle = Paint()
      ..strokeWidth = 5
      ..style = PaintingStyle.fill
      ..color = Colors.white;

    canvas.drawCircle(
      Offset(30, size.height  * 0.75), 12, paintCircle);

    //Nombre lugar

    final textSpan =  TextSpan(
        style: const TextStyle(color: Colors.black, fontSize: 30),
        text: name
    );


    final namePlace = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
      maxLines: 2,
      ellipsis: '...',
    )..layout(
      maxWidth: size.width - 55,
      minWidth: size.width - 55
    );

    final double offsetY = (name.length > 14) ? 30 : 50;

    namePlace.paint(canvas,  Offset(48, offsetY));


      //Tipo lugar

    final textSpanType =  TextSpan(
        style: const TextStyle(color: Colors.black45, fontSize: 23),
        text: type
    );


    final typePlace = TextPainter(
      text: textSpanType,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center
    )..layout(
      maxWidth: size.width - 30,
      minWidth: size.width - 30
    );

    typePlace.paint(canvas, const Offset(30, 105));

    


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}
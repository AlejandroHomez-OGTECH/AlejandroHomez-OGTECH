import 'package:flutter/material.dart';

class CustomLogin extends CustomClipper<Path> {
 
  @override
  Path getClip(Size size) {
  
    final path = Path()..moveTo(0, 0);

    path.quadraticBezierTo(size.width * 0.0, size.height * 0.1, size.width * 0.11, size.height * 0.105);
    path.lineTo(size.width * 0.89, size.height * 0.105);
    path.quadraticBezierTo(size.width, size.height * 0.1, size.width, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }

}
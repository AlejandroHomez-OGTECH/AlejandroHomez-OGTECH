import 'package:flutter/material.dart';

class CustomProfile extends CustomClipper<Path> {
 
  @override
  Path getClip(Size size) {
  
    final path = Path()..moveTo(0, 0);

    path.lineTo(0, size.height);
    path.lineTo(size.width , size.height * 0.5);
    path.lineTo(size.width, size.height * 0.0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }

}
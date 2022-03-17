import 'package:flutter/material.dart';

class BackgroundLogin extends StatelessWidget {

  final Widget child;

  BackgroundLogin({required this.child});
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset('assets/fondo.jpg',width: double.infinity,  height: double.infinity,  fit: BoxFit.cover,),
          child,
        ],
      ),
    );
  }
}
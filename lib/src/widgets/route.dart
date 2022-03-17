import 'package:flutter/material.dart';

class RutaPersonalizada {

    PageRouteBuilder<dynamic> rutaPersonalizada(Widget ruta) {
    return PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secundaryAnimation) =>
            ruta,
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secundatyAnimation, child) {
          final curvedAnimation =
              CurvedAnimation(parent: animation, curve: Curves.easeIn);

          return SlideTransition(
            position:
                Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
                    .animate(curvedAnimation),
            child: child,
          );
        });
  }

  PageRouteBuilder<dynamic> rutaPersonalizadaScale(Widget ruta) {
    return PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secundaryAnimation) =>
            ruta,
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secundatyAnimation, child) {
          final curvedAnimation =
              CurvedAnimation(parent: animation, curve: Curves.easeIn);

          return ScaleTransition(
            scale:Tween<double>(begin: 0.1, end: 1.0).animate(curvedAnimation) ,
            child: child,
          );
        });
  }


}



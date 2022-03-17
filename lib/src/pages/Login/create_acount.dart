import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';

import 'package:icebreaking_app/src/widgets/widgets.dart';

import 'package:animate_do/animate_do.dart';

// ignore: use_key_in_widget_constructors
class BodyHomeCrateAcount extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return  Scaffold(
          body: BackgroundLogin(
      child: Container(
        alignment: Alignment.center,
        height: size.height,
        child: Stack(
          children: [
            //Logo
            Positioned(top: 0, left: 0, right: 0, child: _LogoIceBreaking()),

            //Formulario

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Stack(
                children: [
                  SizedBox(
                    width: size.width,
                    height: size.height * 0.608,
                    child: ClipPath(
                      clipper: CustomLogin(),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                        child: Container(
                          width: 100,
                          height: 100,
                          color: Colors.black45,
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                const SizedBox(height: 50),
                                FormLoginCreate(),
                                _TextCreateAcount(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  //
                ],
              ),
            ),
          ],
        ),
      ),
    )
      );
  }
}

class _TextCreateAcount extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushReplacementNamed(context, 'login'),
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        width: double.infinity,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('¡Ya tengo una cuenta!', style: TextStyle(fontWeight: FontWeight.w200, color: Colors.white),),
            SizedBox(width: 5),
            Text('Iniciar', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
        ]),
      ),
    );
  }
}




class _LogoIceBreaking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        padding: const EdgeInsets.all(40),
        width: double.infinity,
        height: size.height * 0.456,
        decoration: const BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40))),
        child: Stack(
          children: [
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(45),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ZoomIn(
                  child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 80,
                      child: Image.asset(
                        'assets/logo_fondo_blanco.png',
                        height: 130,
                        fit: BoxFit.contain,
                      )),
                )),

            //Linea interior
            Spin(
              duration: const Duration(seconds: 2),
              spins: 1,
              child: SizedBox(
                width: double.infinity,
                child: CustomPaint(
                  size: Size.infinite,
                  painter: CustomLineLogo1(),
                ),
              ),
            ),

            //Linea Medio

            Spin(
              duration: const Duration(seconds: 2),
              spins: -1,
              child: SizedBox(
                width: double.infinity,
                child: CustomPaint(
                  size: Size.infinite,
                  painter: CustomLineLogo2(),
                ),
              ),
            ),

            //Linea Exterior

            Spin(
              duration: const Duration(seconds: 2),
              spins: 1,
              child: SizedBox(
                width: double.infinity,
                child: CustomPaint(
                  size: Size.infinite,
                  painter: CustomLineLogo3(),
                ),
              ),
            )
          ],
        ));
  }
}
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:icebreaking_app/src/pages/pages.dart';
import 'package:icebreaking_app/src/preferencias/preferencias_usuario.dart';
import 'package:icebreaking_app/src/services/profile_service.dart';
import 'package:icebreaking_app/src/services/services.dart';
import 'package:icebreaking_app/src/styles/styles.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {


  
  final pref = PreferenciasUsurario();


    Future.delayed(const Duration(seconds: 2), ()  async {

      if (auth.currentUser == null) {  

      if(pref.primeraVez == true) {
        Navigator.pushReplacement(context, PageRouteBuilder(
          pageBuilder: (_, __ , ___ ) => OnBoardingPage(),
          transitionDuration: const Duration(seconds: 1))
          );
      } else {
        Navigator.pushReplacement(context, PageRouteBuilder(
          pageBuilder: (_, __ , ___ ) => LoginPage(),
          transitionDuration: const Duration(seconds: 1))
          );
      }
        
        
      } else {

        final authServices = Provider.of<AuthService>(context, listen: false);
        final socketService = Provider.of<SocketService>(context, listen: false);

        await authServices.login(pref.email);
        socketService.connect();  
          
           Navigator.pushReplacement(context, PageRouteBuilder(
                pageBuilder: (_, __ , ___ ) => HomePage(),
                transitionDuration: const Duration(milliseconds: 300))
        );
        // _validacion();
        
      }
    });


    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
        gradient: MyStyles().gradientDiagonal

        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Center(
              child: ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (rect) {
                  return const LinearGradient(colors: [
                    Colors.white,
                    Colors.white
                  ]).createShader(rect);

                },
                child: Padding(
                  padding: const EdgeInsets.all(110),
                  child: Image.asset('assets/logo_fondo_blanco.png'),
                ))
            ),

              Positioned(
                  bottom: 45,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: const [
                           Text('Powered By', style: TextStyle(color: Colors.white70),),
                           Text(' OG TECH', style: TextStyle(color: Colors.white),),
                        ],
                      ),
                     const SizedBox(height:5),
                     const Text('©2022 Todos los derechos reservados', style: TextStyle(color: Colors.white70, fontSize: 11),),
                    ],
                  ))
          ],
        ),
      ),
    );
  }

}
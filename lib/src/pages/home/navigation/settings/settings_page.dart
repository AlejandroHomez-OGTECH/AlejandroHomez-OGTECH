import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icebreaking_app/src/models/models.dart';
import 'package:icebreaking_app/src/services/services.dart';
import 'package:icebreaking_app/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [

            SizedBox(
              width: size.width,
              height: size.height * 0.52,
              child: CustomPaint(
                painter: CustomSettings(),
              ),
            ),

            Positioned(
              top: 50,
              left: 0,
              child: IconButton(onPressed: () => Navigator.pop(context), 
              icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.white, size: 30)),
            ),

            _CerrarSesion()

          ],
        ),
      ),
    );
  }
}

class _CerrarSesion extends StatelessWidget {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {

    final providerLogin = Provider.of<AuthClass>(context);
  final socketService = Provider.of<SocketService>(context);
  final profileService = Provider.of<ProfileServices>(context);


    return Positioned(
      bottom: 50,
      left: 12,
      child: GestureDetector(
        onTap: () async {

          socketService.disconnect();


          if (providerLogin.inicioGoogle) {
             await providerLogin.signOutGmail();
              _auth.signOut();
              Navigator.pushReplacementNamed(context, 'login');
            } else {
              await providerLogin.signOutFb();
              _auth.signOut();
              Navigator.pushReplacementNamed(context, 'login');
            } 
          
            AuthService.deleteToken();
                 
        },
        child: Container(
          padding: const EdgeInsets.all(5),
          child: Row(
            children:  const [
           RotatedBox(
                 quarterTurns: 2,
                child: Icon(Icons.logout_outlined)),
            SizedBox(width: 5),
            Text('Cerra sesion', style: TextStyle(fontSize: 20),)
              
              
              ],
          ),
        ),
      )
    
    );
  }
}
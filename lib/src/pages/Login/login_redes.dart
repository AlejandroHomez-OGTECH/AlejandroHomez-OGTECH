import 'dart:ui';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';

import 'package:icebreaking_app/src/models/models.dart';
import 'package:icebreaking_app/src/pages/Login/login_number.dart';
import 'package:icebreaking_app/src/pages/pages.dart';
import 'package:icebreaking_app/src/services/auth_service.dart';
import 'package:icebreaking_app/src/services/profile_service.dart';
import 'package:icebreaking_app/src/services/services.dart';
import 'package:icebreaking_app/src/styles/styles.dart';
import 'package:icebreaking_app/src/widgets/widgets.dart';

import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _HomePageState();
}

class _HomePageState extends State<LoginPage> {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container();
          } else if (snapshot.connectionState == ConnectionState.done) {
            return BodyHome();
          }

          return Center(
            child: CircularProgressIndicator(
              backgroundColor: MyStyles().colorAzul,
              color: MyStyles().colorRojo,
            ),
          );
        });
  }
}

class BodyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
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
                                FormLogin(),
                                _TextCreateAcount(),
                                _Botones(),
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
    ));
  }
}

class _TextCreateAcount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    return GestureDetector(
      onTap: () => Navigator.pushReplacementNamed(context, 'createAcount'),
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        width: double.infinity,
        alignment: Alignment.center,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
          Text(
            '¿No tienes una cuenta?',
            style: TextStyle(fontWeight: FontWeight.w300, color: Colors.white),
          ),
          SizedBox(width: 5),
          Text(
            'Crear',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
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
                    child: Image.asset('assets/logo_fondo_blanco.png', height: 130,fit: BoxFit.contain,)
                  ),
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

class _Botones extends StatefulWidget {

  @override
  State<_Botones> createState() => _BotonesState();
}

class _BotonesState extends State<_Botones> {

  String _email = '';

  @override
  void initState() {
    _setEmail(_email);
    super.initState();
  }

  _setEmail(String valor) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('email', valor);
    _email = valor;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    final providerLogin = Provider.of<AuthClass>(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
        topRight: Radius.circular(40),
        topLeft: Radius.circular(40),
      )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _Button(
              color: Colors.blueAccent,
              colorIcon: Colors.white,
              texto: 'Login con Facebook',
              icon: FontAwesomeIcons.facebook,
              onTap: () {

               AuthClass()
                  .signConFacebook(context)
                  .then((UserCredential value) async {

                    final newProfileServices = Provider.of<ProfileServices>(context, listen: false);
                    final authServices = Provider.of<AuthService>(context, listen: false);
                    final socketService = Provider.of<SocketService>(context, listen: false);

                    providerLogin.nombreUsuario = value.user!.displayName!;
                    providerLogin.emailUsuario = value.user!.email!;
                    providerLogin.urlImageUsuario = value.user!.photoURL!;

                      _setEmail(value.user!.email!);

                    providerLogin.setInicioGoogle = false;

              
                bool verificacion = await newProfileServices.verificarPerfil(value.user!.email!);
                
                if (verificacion) {
                    
                    socketService.connect(); 
                    await authServices.login(providerLogin.emailUsuario);

                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => HomePage()),
                      (route) => false);

                } else {

                  
                 newProfileServices.newUser = UserIce(
                      fullName: value.user!.displayName!,
                      gender: 0,
                      email: value.user!.email!,
                      youSearch: 'Amistad',
                      edadRangeDesde: 18,
                      edadRangeHasta: 80,
                      howAmI: 0,
                      profilePhoto: '',
                      dateOfBirth: Timestamp.fromDate(DateTime(2000, 01, 01)),
                      interest: 'Hombres',
                      likes: 0,
                      ancestry: '',
                      biography: '',
                      languages: [],
                      myPictures: [],
                      phoneNumber: '',
                      profession: '',
                      socialNetworks: ['', '', ''],
                      selfiePhoto: '',
                      myLikes: [],
                      likesMe: [],
                      iceMe: [],
                      myIces: [],
                      match: [],
                      online: false,
                    );

                  newProfileServices.loadUsersIceProfile(value.user!.email!);
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => NewProfilePage()),
                      (route) => false);
                 }
                }
                );

        
 

              }),
          _Button(
            color: Colors.red,
            colorIcon: Colors.white,
            texto: 'Login con Gmail',
            icon: FontAwesomeIcons.googlePlus,
            onTap: () async {



              AuthClass().signWithGoogle().then((UserCredential value) async {
                providerLogin.nombreUsuario = value.user!.displayName!;
                providerLogin.emailUsuario = value.user!.email!;
                providerLogin.urlImageUsuario = value.user!.photoURL!;

                _setEmail(value.user!.email!);

                providerLogin.setInicioGoogle = true;

                final newProfileServices = Provider.of<ProfileServices>(context, listen: false);

                 bool verificacion = await newProfileServices.verificarPerfil(value.user!.email!);

                if (verificacion) {

                  final authServices = Provider.of<AuthService>(context, listen: false);
                  final profileServices = Provider.of<ProfileServices>(context, listen: false);
                  final socketService = Provider.of<SocketService>(context, listen: false);

                  await authServices.login(value.user!.email!);
                  await profileServices.loadUsersIceProfile(value.user!.email!);
                  socketService.connect();  
          
                    Navigator.pushReplacement(context, PageRouteBuilder(
                          pageBuilder: (_, __ , ___ ) => HomePage(),
                          transitionDuration: const Duration(milliseconds: 300))
                  );

                } else {
                  
                newProfileServices.newUser = UserIce(
                      fullName: value.user!.displayName!,
                      gender: 0,
                      email: value.user!.email!,
                      youSearch: 'Amistad',
                      edadRangeDesde: 18,
                      edadRangeHasta: 80,
                      howAmI: 0,
                      profilePhoto: '',
                      dateOfBirth: Timestamp.fromDate(DateTime(2000, 01, 01)),
                      interest: 'Hombres',
                      likes: 0,
                      ancestry: '',
                      biography: '',
                      languages: [],
                      myPictures: [],
                      phoneNumber: '',
                      profession: '',
                      socialNetworks: ['', '', ''],
                      selfiePhoto: '',
                      myLikes: [],
                      likesMe: [],
                      iceMe: [],
                      myIces: [],
                      match: [],
                      online: false);

                  await newProfileServices.loadUsersIceProfile(value.user!.email!);
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => NewProfilePage()),
                      );
                }
                
              });


            },
          ),

        (Platform.isAndroid) 
        ? Container()
        : _Button(
              color: Colors.white,
              colorIcon: Colors.black,
              texto: 'Login con Apple',
              icon: FontAwesomeIcons.apple,
              onTap: (){}
              ),

        
        _Button(
              color: MyStyles().colorNaranja, 
              colorIcon: Colors.white,
              texto: 'Login numero',
              icon: FontAwesomeIcons.phone,
              onTap: (){
                
                  Navigator.push(context, RutaPersonalizada().rutaPersonalizada(Login_phoneNumber()));

              }
              )
        ],
      ),
    );
  }
}

class _Button extends StatelessWidget {
  final Color color;
  final Color colorIcon;
  final String texto;
  final IconData icon;
  final VoidCallback onTap;

  _Button({
    required this.color,
    required this.texto,
    required this.icon,
    required this.onTap,
    required this.colorIcon,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return FadeInUp(
      from: 20,
      child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.only(bottom: 5),
            alignment: Alignment.center,
            margin: const EdgeInsets.all(10),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(blurRadius: 2, color: color, spreadRadius: 0.5)
              ],
              // borderRadius: const BorderRadius.all(Radius.circular(30)),
            ),
            child: Icon(
              icon,
              color: colorIcon,
              size: 30,
            ),
          )),
    );
  }
}
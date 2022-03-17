import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:icebreaking_app/src/providers/formuser_provider.dart';
import 'package:icebreaking_app/src/services/auth_service.dart';
import 'package:icebreaking_app/src/services/newprofile_service.dart';

import 'package:icebreaking_app/src/styles/styles.dart';
import 'package:icebreaking_app/src/widgets/CustomsPainters/customregistro.dart';
import 'package:icebreaking_app/src/widgets/widgets.dart';
import 'package:icebreaking_app/src/models/models.dart';
import 'package:icebreaking_app/src/services/services.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class NewProfilePage extends StatelessWidget {
  
  Future<String> usuario() async {
    String? user = (FirebaseAuth.instance.currentUser!.email == null)
        ? FirebaseAuth.instance.currentUser!.phoneNumber
        : FirebaseAuth.instance.currentUser!.email;
    return user!;
  }

  @override
  Widget build(BuildContext context) {
    final profileServices = Provider.of<ProfileServices>(context);
    final newProfileServices = Provider.of<NewProfileServices>(context);

    final size = MediaQuery.of(context).size;

    return ChangeNotifierProvider(
      create: (_) => FormProfileProvider(profileServices.newUser),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
              alignment: Alignment.bottomCenter,
              children: [

                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [

                      const SizedBox(height: 125),
    
                      SizedBox(
                        width: size.width,
                        height: 570,
                        child: PageView(
                          physics: const BouncingScrollPhysics(parent: NeverScrollableScrollPhysics()),
                          scrollDirection: Axis.horizontal,
                          controller: newProfileServices.pageController,
                          onPageChanged: (page) => newProfileServices.setPaginaActual = page,
                          children: [
                            FormPage1(),
                            FormPage2(),
                            FormPage3(),
                          ],
                        ),
                      ),
    
                    ],
                  ),
                ),

                
                 Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    child: Column(
                      children: [
                        _HeaderProfile(),
                        _BarraDeProgreso(),
                      ],
                    )),
    
              ],
            ),
            
            bottomNavigationBar: _NavigationBar(),
        ),
    );
  }
}

class _BarraDeProgreso extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final newProfileServices = Provider.of<NewProfileServices>(context);
    final size = MediaQuery.of(context).size;

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        color: Colors.white70,

      width: double.infinity,
      height: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [

          Stack(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                height: 5,
                width: size.width * 0.8,
                color: Colors.black12
              ),

              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: size.width *  newProfileServices.porcentaje,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                height: 5,
                decoration: BoxDecoration(
                  gradient: MyStyles().gradientHorizontal
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween ,
            children:  [

            Container(
              padding: const EdgeInsets.all(4),
              decoration: 
              BoxDecoration(
              color:  newProfileServices.paginaActual  < 3 ? MyStyles().colorAzul :Colors.grey.shade200 ,
              shape: BoxShape.circle
              ),
              child: const Icon(Icons.person,  color:Colors.white)),

              Container(
              padding: const EdgeInsets.all(4),
              decoration: 
              BoxDecoration(
              color: newProfileServices.paginaActual >= 1  ? MyStyles().colorRojo :Colors.grey.shade200,
              shape: BoxShape.circle
              ),
              child: const Icon(Icons.insert_chart_outlined_outlined, color: Colors.white)),

              Container(
              padding: const EdgeInsets.all(4),
              decoration: 
              BoxDecoration(
              color: newProfileServices.paginaActual == 2 ? MyStyles().colorRojo :Colors.grey.shade200,
              shape: BoxShape.circle
              ),
              child: const Icon(Icons.photo, color: Colors.white)),

            ],
          ),
        ],
      )
    );
  }
}

class _HeaderProfile extends StatelessWidget {

  String urlPhoto =  "https://www.elivapress.com/public/authors/b22c171bd7c77f05532eff05b4bacde2.png";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final newProfileService = Provider.of<NewProfileServices>(context);
    final providerLogin = Provider.of<AuthClass>(context);

    return Container(
      width: double.infinity,
      height: 90,
      padding: const EdgeInsets.only(top: 0, bottom: 10),
      child: CustomPaint(
          painter: CustomRegistro(),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: IconButton(
                onPressed: () {
                  switch (newProfileService.paginaActual) {
                    case 0:
                      {
                        if (providerLogin.inicioGoogle) {
                          providerLogin.signOutGmail();
                          Navigator.pushReplacementNamed(context, 'login');
                        } else {
                          providerLogin.signOutFb();
                          Navigator.pushReplacementNamed(context, 'login');
                        }
                      }
                      break;
                    case 1:
                      {
                        int pagina = newProfileService.paginaActual - 1;
                        newProfileService.setPaginaActual = pagina;
                      }
                      break;
                    case 2:
                      {
                        int pagina = newProfileService.paginaActual - 1;
                        newProfileService.setPaginaActual = pagina;
                      }
                      break;
                    default:
                      () {};
                  }
                },
                icon: RotatedBox(
                    quarterTurns: newProfileService.paginaActual == 0 ? 2 : 0,
                    child: Icon(
                        newProfileService.paginaActual == 0
                            ? Icons.logout_outlined
                            : Icons.arrow_back_ios_new_rounded,
                        size: 28,
                        color: Colors.white))),
            ),
          ),
      ),
    );
  }
}

class _ImagenProfile extends StatelessWidget {
  String photoProfile =
      "https://www.elivapress.com/public/authors/b22c171bd7c77f05532eff05b4bacde2.png";

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<ProfileServices>(context).newUser;

    return Container(
      alignment: Alignment.bottomRight,
      width: 140,
      height: 140,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                color: Colors.black26, blurRadius: 15, offset: Offset(0, 15))
          ],
          shape: BoxShape.circle,
          image: DecorationImage(
              image: NetworkImage(
                  user.profilePhoto == '' ? photoProfile : user.profilePhoto),
              fit: BoxFit.cover)),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5, right: 5),
        child: GestureDetector(
          onTap: () {},
          child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15,
                    offset: Offset(0, 12))
              ], color: Colors.white, shape: BoxShape.circle),
              child: ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (rect) {
                    return MyStyles().gradientHorizontal.createShader(rect);
                  },
                  child: const Icon(Icons.add_circle_sharp, size: 30))),
        ),
      ),
    );
  }
}

class _NavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final newProfileServices = Provider.of<NewProfileServices>(context);
    final profileServices = Provider.of<ProfileServices>(context);
    final formProvider = Provider.of<FormProfileProvider>(context);
    
          return GestureDetector(
        onTap: () async {

             switch (newProfileServices.paginaActual) {
                  case 0:
                    {
                      int pagina = newProfileServices.paginaActual + 1;
                      newProfileServices.setPaginaActual = pagina;
                    }
                    break;
                  case 1:
                    {
                      int pagina = newProfileServices.paginaActual + 1;
                      newProfileServices.setPaginaActual = pagina;
                    }
                    break;
                  case 2:
                    {
                      final socketService = Provider.of<SocketService>(context, listen: false);
                      final authService = Provider.of<AuthService>(context, listen: false);
                      
                      await profileServices.createUserIce(formProvider.user);
                      await authService.register(formProvider.user.id! , formProvider.user.fullName, formProvider.user.email );
                      
                      socketService.connect();

                      Navigator.pushReplacementNamed(context, 'home');

                      Timer(const Duration(seconds: 1), (){
                        newProfileServices.setPaginaActual = 0;
                        newProfileServices.setQueBuco = 0;
                        newProfileServices.setPorcentaje = 0;
                        newProfileServices.setGenero = 0; 
                      });

                    
                    }
                    break;
                  default:
                    () {};
                }
         
    
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            color: MyStyles().colorRojo
),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
              
               Text(
                newProfileServices.paginaActual == 2
                ? 'Crear Cuenta'
                : 'Siguiente',
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
             
             const Icon(Icons.navigate_next_rounded, color: Colors.white, size: 35)

            ],
          ),
        ),
      );
  }
}
import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:icebreaking_app/src/models/models.dart';
import 'package:icebreaking_app/src/models/usuario.dart';
import 'package:icebreaking_app/src/pages/pages.dart';
import 'package:icebreaking_app/src/services/profile_service.dart';
import 'package:icebreaking_app/src/services/services.dart';
import 'package:icebreaking_app/src/services/usuarios_services.dart';
import 'package:icebreaking_app/src/styles/styles.dart';
import 'package:icebreaking_app/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

class MatchWiget extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context) => _NotificatinAnimation(),
      child: _BodyAnimation());
  }
}

class _BodyAnimation extends StatefulWidget {

  @override
  State<_BodyAnimation> createState() => _BodyAnimationState();
}

class _BodyAnimationState extends State<_BodyAnimation>  with SingleTickerProviderStateMixin {

  late AnimationController controller;
  late Animation<double> izquierda;
  late Animation<double> abajo;
  late Animation<double> derecha;

  double opacidad =  0.7;

  late Animation<double> zoom;

  
  final usuarioServices = UsuariosService();
  List<Usuario> usuarios = [];

  @override
  void initState() {

    controller = AnimationController(vsync: this, duration: const Duration(seconds: 3));
  
    controller.addListener(() { 
      

      setState(() {
        
      });
      
        if (controller.isAnimating) {
          opacidad = 0.0;
        } else if(controller.isDismissed) {
          opacidad =  0.7;
        }

    });

    izquierda = Tween(begin: -20.0, end: -250.0).animate(
      CurvedAnimation(parent: controller, curve: const Interval(0.0, 0.6, curve: Curves.easeInExpo))
    );

    
    abajo = Tween(begin: 20.0, end: 350.0).animate(
      CurvedAnimation(parent: controller, curve: const Interval(0.0, 0.6, curve: Curves.easeInExpo))
    );


    derecha = Tween(begin: 20.0, end: 250.0).animate(
      CurvedAnimation(parent: controller, curve:const Interval(0.0, 0.6 , curve: Curves.easeInExpo))
    );

    zoom = Tween(begin: 0.5, end: 3.0).animate(
      CurvedAnimation(parent: controller, curve:const Interval(0.5, 1.0, curve:  Curves.easeInOutBack))
    );

    super.initState();
   _cargarUsuarios();

  }

  Future<Usuario> getUsuraio(String idUser)  async {

    late Usuario usuario;

      for (var i = 0; i < usuarios.length; i++) {
        if (usuarios[i].idFirebase == idUser) {
          usuario = usuarios[i];
          break;
        }
      }

    return usuario;

  }


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    controller.forward();

    final profileServices = Provider.of<ProfileServices>(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Column( 
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 500,
                  child:  Stack(
                    alignment: Alignment.center,
                    children: [

                      AnimatedBuilder(
                        animation: controller,
                        builder: (context, Widget? child) {
                            return  Transform.scale(
                              scale: zoom.value,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                      width: 50,
                                      child: Image.asset('assets/logo_fondo_blanco.png',
                                          fit: BoxFit.contain),
                                    ),

                                  controller.isCompleted
      
                                    ? SizedBox(
                                      width: 150,
                                      height: 150,
                                      child: Stack(
                                        children: [
                                          
                                          Positioned(
                                            top: 0,
                                            right: 35,
                                            child: FadeInUp(
                                              from: 15,
                                              child: ZoomIn(
                                                duration: const Duration(seconds: 2),
                                                child: Image.asset('assets/polvora1.gif',height: 45,)))
                                          ),
                                    
                                          Positioned(
                                            top: 35,
                                            left: 20,
                                            child: FadeInUp(
                                              from: 15,
                                          
                                              child: ZoomIn(
                                                delay: const Duration(milliseconds: 500),
                                                child: Image.asset('assets/polvora2.gif',height: 30,)))
                                          ),
                                    
                                          Positioned(
                                            bottom: 30,
                                            right: 20,
                                            child: FadeInUp(
                                              child: ZoomIn(
                                                delay: const Duration(milliseconds: 1000),
                                                child: Image.asset('assets/polvora3.gif',height: 30,)))
                                          ),
                                    
                                    
                                        ],
                                      ))     
                                    : Container()
                                ],
                              ),
                            );
                        },
          
                      ),

                      AnimatedOpacity(
                        duration: const Duration(seconds: 2),
                        opacity: opacidad,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [

                              Positioned(
                                top: 190,
                                right: 90,
                                child: AnimatedBuilder(
                                  animation: controller,
                                  builder: (context , Widget? child) {
                                    return  Transform.translate(
                                      offset: Offset(izquierda.value, 0.0),
                                      child: Image.asset('assets/parte1.png', width: 150),
                                    );
                                  },
                                ),
                              ),
                              Positioned(
                                top: 190,
                                right: 130,
                                child: AnimatedBuilder(
                                  animation: controller,
                                  builder: (context , Widget? child) {
                                  return Transform.translate(
                                    offset: Offset(derecha.value, 0.0 ),
                                    child: Image.asset('assets/parte2.png', width: 150),
                                  );
                                  }
                                            
                                ),
                              ),

                                Positioned(
                                  top: 170,
                                  right: 110,
                                  child: AnimatedBuilder(
                                    animation: controller,
                                    builder: (context, Widget? child) {
                                      return Transform.translate(
                                        offset: Offset(0.0, abajo.value),
                                        child: Image.asset('assets/parte3.png',
                                            width: 150),
                                      );
                                    }),
                                ),
                              
                          ],
                        ),
                      ),

                      
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _InfoPageUsers()),
              ],
            ),


            Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [


                  MaterialButton(
                    padding: const EdgeInsets.all(0),
                    minWidth: 150,
                    onPressed: () => Navigator.pop(context),
                    child: Container(
                      width: 150,
                      padding: const EdgeInsets.all(23),
                      decoration:  BoxDecoration(
                        color: MyStyles().colorRojo,
                        borderRadius: const BorderRadius.all(Radius.circular(100))
                      ),
                      child: const Center(child: Text('Volver', style: TextStyle(color: Colors.white),)),
                    ),
                    
                    ),

                    MaterialButton(
                    padding: const EdgeInsets.all(0),
                    minWidth: 150,
                    onPressed: () async {

                      final chatServices = Provider.of<ChatServices>(context, listen: false);
                      final chatServicesPara =  Provider.of<ChatServicePara>(context, listen: false);
                        chatServices.userChatSelected = profileServices.tempUser;

                       
                        Usuario usuario = await getUsuraio(profileServices.tempUser.id!);
                        chatServicesPara.usuarioPara = usuario;                        

                         Navigator.pushReplacement(context,RutaPersonalizada().rutaPersonalizadaScale(ChatSelected()));

                    },
                    child: Container(
                      width: 150,
                      padding: const EdgeInsets.all(20),
                      decoration:  BoxDecoration(
                        gradient: MyStyles().gradientRedToOrange,
                        borderRadius: const BorderRadius.all(Radius.circular(100))
                      ),
                      child:  Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.message, color: Colors.white),
                          SizedBox(width: 10),
                          Text('Mensaje', style: TextStyle(color: Colors.white),),
                        ],
                      )),
                    ),
                    
                    )
                ],
              ),
            )

          ],
        ),
      ),
    );
  }

   _cargarUsuarios() async {
    usuarios = await usuarioServices.getUsuarios();
    setState(() {});
  }
}

class _InfoPageUsers extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    final profileServices = Provider.of<ProfileServices>(context);
    final size = MediaQuery.of(context).size;

    UserIce myUser = profileServices.newUser;
    UserIce userProfile = profileServices.tempUser;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 80,
          child: Stack(
            alignment: Alignment.center,
            children: [

              Positioned(
                right: size.width * 0.33,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400, width: 3),
                    color: MyStyles().colorNaranja,
                    shape: BoxShape.circle,
                    image: DecorationImage(image: NetworkImage(userProfile.profilePhoto), fit: BoxFit.cover)
                  ),
                ),
              ),

                Positioned(
                left: size.width * 0.33,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400, width: 3),
                    shape: BoxShape.circle,
                    image: DecorationImage(image: NetworkImage(myUser.profilePhoto),  fit: BoxFit.cover)
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        Text('Tú y ${userProfile.fullName} break the ice', style: const TextStyle(color: Colors.black,)),

        const SizedBox(height: 10),

        Text('${userProfile.fullName} y tú estan listos para inicar una conversacion, piensa bien lo que vas a decir.', style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w100, fontStyle: FontStyle.italic), textAlign: TextAlign.center,)

      ],
    );
  }
}

class _NotificatinAnimation extends ChangeNotifier{


 late AnimationController _temblarController;

  AnimationController get temblarController => _temblarController;
  set setTemblarController(AnimationController controller) {
    _temblarController = controller;
  }

  late AnimationController _zoomController;

  AnimationController get zoomController => _zoomController;
  set setZoomController(AnimationController controller) {
    _zoomController = controller;

  }


}
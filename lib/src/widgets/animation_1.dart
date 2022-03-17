
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnimationIce extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context) => _NotificatinAnimation(),
      child: _HomeAnimation(),
    );
  }
}

class _HomeAnimation extends StatefulWidget {

  @override
  State<_HomeAnimation> createState() => _HomeAnimationState();
}

class _HomeAnimationState extends State<_HomeAnimation> with SingleTickerProviderStateMixin {

  late AnimationController controller;
  late Animation<double> izquierda;
  late Animation<double> abajo;
  late Animation<double> derecha;

  double opacidad =  0.7;

  late Animation<double> zoom;

  @override
  void initState() {

    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));

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
  }


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: SizedBox(
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
      ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    floatingActionButton: Bontones(controller)
    );
  }
}


class Bontones extends StatelessWidget {

  AnimationController controller;
  Bontones(this.controller);


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
      FloatingActionButton(
          onPressed: () {
          controller.reverse();
          },
          backgroundColor: Colors.red,
          child: const Icon(Icons.play_arrow_rounded, size: 40),
        ),

        FloatingActionButton(
          onPressed: () {

          controller.forward(from:0.0);

          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.play_arrow_rounded, size: 40),
        ),
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
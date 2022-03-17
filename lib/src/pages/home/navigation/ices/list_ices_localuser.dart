import 'package:flutter/material.dart';
import 'package:icebreaking_app/src/models/usericebreaking_model.dart';
import 'package:icebreaking_app/src/pages/home/homepage.dart';
import 'package:icebreaking_app/src/providers/providers.dart';
import 'package:icebreaking_app/src/services/services.dart';
import 'package:icebreaking_app/src/styles/styles.dart';
import 'package:icebreaking_app/src/widgets/CustomsPainters/customregistro.dart';
import 'package:icebreaking_app/src/widgets/route.dart';
import 'package:icebreaking_app/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ListIcePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(

        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
           child: Column(
             children: [
              _HeaderProfile(),
              _HomeMode(),

               Expanded(
                      child: Stack(
                        children: [
      
                       SizedBox(
                         width: double.infinity,
                         height: size.height * 0.75,
                         child: _Pages()),
                    
                       Positioned(
                          bottom: 0,
                          left: 0,
                          right:0,
                          child: SizedBox(
                                  width: 500,
                                  height: 100,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child: NavigationBarIce()),
                                     _LogoICeBreaking(),
                                      // _BottomSelfie(),
                                    ],
                                  ),
                                ),
                        ),  
                    
                        ],
                      ),
                    ),
               
             ],
           ),
        ),
    );
  }
}

class _LogoICeBreaking extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Center(
         child: ShaderMask(
             blendMode: BlendMode.srcIn,
             shaderCallback: (rect) {
               return const LinearGradient(
                       colors: [Colors.white, Colors.white])
                   .createShader(rect);
             },
             child: Image.asset(
               'assets/logo_fondo_blanco.png',
               height: 53,
             ))
       ),
    );
  }
}

class _HeaderProfile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

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
              child: Row(
                children: [
                   IconButton( 
                   onPressed: () => Navigator.push(context, RutaPersonalizada().rutaPersonalizada(HomePage())), 
                    icon: const  Icon(Icons.arrow_back_ios_new_outlined), color: Colors.white),

                  const Spacer(),

                ],
              )
            ),
          ),
      ),
    );
  }
}

class _HomeMode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final homeProvider = Provider.of<HomeProvider>(context);

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => homeProvider.setPaginaActualIce = 0,
            child: Container(
              color: Colors.transparent,
              child: Column(
                children: [
                  const Text(
                    'Interesados',
                    style: TextStyle(fontSize: 25, letterSpacing: -0.5),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: 5,
                    decoration: BoxDecoration(
                        gradient: homeProvider.paginaActualIce == 0
                            ? MyStyles().gradientHorizontal
                            : LinearGradient(colors: [
                                Colors.grey.shade200,
                                Colors.grey.shade200,
                              ])),
                  )
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => homeProvider.setPaginaActualIce = 1,
            child: Container(
              color: Colors.transparent,
              child: Column(
                children: [
                  const Text(
                    'Me interesan',
                    style: TextStyle(fontSize: 25, letterSpacing: -0.5),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: 5,
                    decoration: BoxDecoration(
                        gradient: homeProvider.paginaActualIce == 1
                            ? MyStyles().gradientHorizontal
                            : LinearGradient(colors: [
                                Colors.grey.shade200,
                                Colors.grey.shade200,
                              ])),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}


//Pages

class _Pages extends StatelessWidget {

  @override
  Widget build(BuildContext context) {    

    final homeProvider = Provider.of<HomeProvider>(context);

    return PageView(
      // physics: const BouncingScrollPhysics(parent: NeverScrollableScrollPhysics()),
      controller: homeProvider.pageControllerIce,
      onPageChanged: (page) => homeProvider.setPaginaActualIce = page,
      scrollDirection: Axis.horizontal,
      children: [
          _PageInteresados(),
          _PageMeInteresan()
      ],
    );
  }
}

class _PageInteresados extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

  final profileServices = Provider.of<ProfileServices>(context);

  List<String> listaUsers = profileServices.newUser.iceMe!;

    return FutureBuilder(
      future: profileServices.loadUsersFromList(listaUsers),
      builder: (BuildContext context, AsyncSnapshot<List<UserIce>> snapshot) { 


        if (snapshot.data == null) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: MyStyles().colorAzul,
              color: MyStyles().colorRojo,
            ),
          );
        }

        List<UserIce> listUserIce = snapshot.data!;

          return  SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: listUserIce.length,
                  itemBuilder: (context, i) => Center(child: ItemIceNavigation(user: listUserIce[i])
                )
              ),
            );
       },

    );
  }
}


class _PageMeInteresan extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

  final profileServices = Provider.of<ProfileServices>(context);

  List<String> listaUsers = profileServices.newUser.myIces!;

    return FutureBuilder(
      future: profileServices.loadUsersFromList(listaUsers),
      builder: (BuildContext context, AsyncSnapshot<List<UserIce>> snapshot) { 


        if (snapshot.data == null) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: MyStyles().colorAzul,
              color: MyStyles().colorRojo,
            ),
          );
        }
        List<UserIce> listUserIce = snapshot.data!;

          return  SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: listUserIce.length,
                  itemBuilder: (context, i) => Center(child: ItemIceNavigation(user: listUserIce[i])
                )
              ),
            );
       },

    );
  }
}
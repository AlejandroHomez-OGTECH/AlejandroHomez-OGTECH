import 'dart:async';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:icebreaking_app/src/models/models.dart';

import 'package:icebreaking_app/src/pages/pages.dart';
import 'package:icebreaking_app/src/preferencias/preferencias_usuario.dart';
import 'package:icebreaking_app/src/providers/homeprovider.dart';
import 'package:icebreaking_app/src/providers/providers.dart';
import 'package:icebreaking_app/src/services/newprofile_service.dart';
import 'package:icebreaking_app/src/services/services.dart';
import 'package:icebreaking_app/src/styles/styles.dart';

import 'package:icebreaking_app/src/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late Future<UserIce> _value;
  late ProfileServices  profileServices;
  final pref = PreferenciasUsurario();

  @override
  void initState() {
    profileServices = Provider.of<ProfileServices>(context, listen: false);
    _value = profileServices.loadUsersIceProfile(pref.email);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

      return FutureBuilder<UserIce>(
          future: _value,
          builder: (context, AsyncSnapshot<UserIce> snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
                child: CircularProgressIndicator(
              backgroundColor: MyStyles().colorAzul,
              color: MyStyles().colorRojo,
            )),
          );
        } 
        
        return ChangeNotifierProvider(
              create: (_) => FormProfileProvider(profileServices.newUser),
                  child:Scaffold(
                    body: SafeArea(
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                                
                                _Header(),
                      
                                SizedBox(
                                  width: double.infinity,
                                  child: _HomeMode(),
                                ),
                                
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
                                              height: 150,
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                      bottom: 0,
                                                      left: 0,
                                                      right: 0,
                                                      child: NavigationBar()),
                                                  _BottomSelfie(),
                                                ],
                                              ),
                                            ),
                                        ),  
                                    ],
                                  ),
                                ),
                              
                              ],
                            ),
                              
                            profileServices.loadSelfie
                            ? Container(
                              color: Colors.black38,
                              child:  Center(child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:  [
                                  const Text('Cargando selfie...', style: TextStyle(color: Colors.white, fontSize: 30)),
                                  const SizedBox(height: 10),
                                  CircularProgressIndicator(
                                    backgroundColor: MyStyles().colorAzul,
                                    color: MyStyles().colorRojo,
                                  ),
                                ],
                              )))
                            : Container()
                          ],
                      ),
                    ),
                  ),
              );
          }
        );
    
  }
}



// Header

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 70),
          Image.asset('assets/logo_fondo_blanco.png', height: 45),
          _PhotoProfile()
          
        ],
      ),
    );
  }
}

class _PhotoProfile extends StatelessWidget {

  String urlfoto = 'https://thumbs.dreamstime.com/b/icono-gris-de-perfil-usuario-s%C3%ADmbolo-empleado-avatar-web-y-dise%C3%B1o-ilustraci%C3%B3n-signo-aislado-en-fondo-blanco-191067342.jpg';
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final user = Provider.of<ProfileServices>(context).newUser;
    final newProfileService = Provider.of<NewProfileServices>(context);

    return GestureDetector(
      onTap: () {
          newProfileService.loadIdiomas(user.languages!);
          Navigator.push(context, RutaPersonalizada().rutaPersonalizada(ProfilePage()));
        
      },
      child: Container(
          width: 70,
          height: 70,
          decoration: const BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40))),
          child: Stack(
            children: [
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(13),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: ZoomIn(
                    child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(image: 
                          NetworkImage(user.profilePhoto == '' ?  urlfoto : user.profilePhoto ), fit: BoxFit.cover, )
                          )
                        )
                  )),
    
              //Linea interior
              Spin(
                duration: const Duration(seconds: 2),
                spins: 1,
                child: SizedBox(
                  width: double.infinity,
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: CustomLineProfile1(),
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
                    painter: CustomLineProfile2(),
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
                    painter: CustomLineProfile3(),
                  ),
                ),
              )
            ],
          )),
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
            onTap: () => homeProvider.setPaginaActual = 0,
            child: Container(
              color: Colors.transparent,
              child: Column(
                children: [
                  const Text(
                    'Ice Breaking',
                    style: TextStyle(fontSize: 25, letterSpacing: -0.5),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: 5,
                    decoration: BoxDecoration(
                        gradient: homeProvider.paginaActual == 0
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
            onTap: () => homeProvider.setPaginaActual = 1,
            child: Container(
              color: Colors.transparent,
              child: Column(
                children: [
                  const Text(
                    'Relax',
                    style: TextStyle(fontSize: 25, letterSpacing: -0.5),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: 5,
                    decoration: BoxDecoration(
                        gradient: homeProvider.paginaActual == 1
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
      physics: const BouncingScrollPhysics(parent: NeverScrollableScrollPhysics()),
      controller: homeProvider.pageController,
      onPageChanged: (page) => homeProvider.setPaginaActual = page,
      scrollDirection: Axis.horizontal,
      children: [
          IceBreakingPage(),
          RelaxPage()
      ],
    );
  }
}


//Navigatio Bar

class _BottomSelfie extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final formProvider = Provider.of<FormProfileProvider>(context);
    final profileServices = Provider.of<ProfileServices>(context);
    final placeService = Provider.of<PlaceService>(context);

    return Positioned(
      bottom: 13,
      left: 0,
      right: 0,
      child: GestureDetector(
          onTap: () async {

          if (placeService.showPlaces.length == 1) {

             final _imagePicker = ImagePicker();

            final XFile? selfiePhoto = await _imagePicker.pickImage(
              source: ImageSource.camera,
              imageQuality: 50,
            );

            if (selfiePhoto == null) {
              // ignore: avoid_print
              print('No selecciono nada');
              return;
            }
            // ignore: avoid_print
            print('Tenemos imagen ${selfiePhoto.path}');

            formProvider.updateSelfiePhoto(selfiePhoto.path);
            profileServices.updateSelectedSelfiePhoto(selfiePhoto.path);

            addSelfiePhoto(context); 
            
          } else {
            
              Navigator.pushReplacement(
                context, 
                RutaPersonalizada().rutaPersonalizada(PlacesIcebreaking())
              );
             
          }


        },

        child: Center(
          child: ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (rect) {
              return const LinearGradient(colors: [Colors.white, Colors.white]).createShader(rect);
            },
            child: Image.asset('assets/logo_fondo_blanco.png', height: 53,))
        
        ),
      ),
    );
  }

  void addSelfiePhoto(BuildContext context) {

   final formProvider = Provider.of<FormProfileProvider>(context, listen: false);
   final profileServices = Provider.of<ProfileServices>(context, listen: false);
   final placeService = Provider.of<PlaceService>(context, listen: false);

    if (Platform.isAndroid) {

      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: const Text('Foto para ingresar a un Iglu', textAlign: TextAlign.center),
              content: SelfiePhoto(user:formProvider.user),
              actions: [
                
                profileServices.loadSelfie == false
                ? MaterialButton(
                    elevation: 5,
                    child: const Text('Cancelar'),
                    textColor: MyStyles().colorRojo,
                    onPressed: () => Navigator.pop(context)
                    )
                : Container(),

                MaterialButton(
                    elevation: 5,
                    textColor: MyStyles().colorRojo,
                    onPressed: profileServices.loadSelfie
                        ? null
                        : () async { 
                        
                      Navigator.pop(context);

                        profileServices.setLoadSelfie = true;

                       final String? selfeUrl = await profileServices.uploadSelfiePhoto(formProvider.user.email);
                        if (selfeUrl != null) {
                          formProvider.updateSelfiePhoto(selfeUrl);
                        }  

                        profileServices.updateUserIce(formProvider.user);
                        profileServices.newUser = formProvider.user;

                        profileServices.setLoadSelfie = false;

                        placeService.tempPlace = placeService.showPlaces[0];

                      if (placeService.tempPlace.users == null) {

                        List<String> lista = [];
                      
                        lista.add(formProvider.user.id!);
                        placeService.tempPlace.users = lista;
                        placeService.updatePlaceIce(placeService.tempPlace);
                        Navigator.push(context, RutaPersonalizada().rutaPersonalizada(IgluSelected()));

                      } else {

                        List<String> lista = placeService.tempPlace.users!;
                        bool repetido =  false;

                        for (var i = 0; i < lista.length; i++) {

                          if (formProvider.user.id! == lista[i]) {
                            repetido = true;
                          }
                          
                        }

                        if (repetido == false) {
                          lista.add(formProvider.user.id!);
                          placeService.tempPlace.users = lista;
                          placeService.updatePlaceIce(placeService.tempPlace);
                          Navigator.push(context, RutaPersonalizada().rutaPersonalizada(IgluSelected()));
                          
                        } else {
                          Navigator.push(context, RutaPersonalizada().rutaPersonalizada(IgluSelected()));

                        }

                      }              
                        
                    },
                    child:  Text( profileServices.loadSelfie ? 'Cargando selfie...' :'Me gusta esta foto'),
                    
                    ),
              ],
            );
          });
    } else {
      showCupertinoDialog(
          context: context,
          builder: (_) {
            return CupertinoAlertDialog(
              title: const Text('Foto para ingresar a un Iglu'),
              content: SelfiePhoto(user: formProvider.user),
              actions: [
                CupertinoDialogAction(
                    child:  Text( profileServices.loadSelfie ? 'Cargando selfie...' :'Me gusta esta foto'),

                    isDefaultAction: true,
                    onPressed: profileServices.loadSelfie
                        ? null
                        : () async { 

                        Navigator.pop(context);

                        profileServices.setLoadSelfie = true;

                       final String? selfeUrl = await profileServices.uploadSelfiePhoto(formProvider.user.email);
                        if (selfeUrl != null) {
                          formProvider.updateSelfiePhoto(selfeUrl);
                        }  

                        profileServices.updateUserIce(formProvider.user);
                        profileServices.newUser = formProvider.user;

                        profileServices.setLoadSelfie = false;

                        placeService.tempPlace = placeService.showPlaces[0];

                      if (placeService.tempPlace.users == null) {

                        List<String> lista = [];
                      
                        lista.add(formProvider.user.id!);
                        placeService.tempPlace.users = lista;
                        placeService.updatePlaceIce(placeService.tempPlace);
                        Navigator.push(context, RutaPersonalizada().rutaPersonalizada(IgluSelected()));

                      } else {

                        List<String> lista = placeService.tempPlace.users!;
                        bool repetido =  false;

                        for (var i = 0; i < lista.length; i++) {

                          if (formProvider.user.id! == lista[i]) {
                            repetido = true;
                          }
                          
                        }

                        if (repetido == false) {
                          lista.add(formProvider.user.id!);
                          placeService.tempPlace.users = lista;
                          placeService.updatePlaceIce(placeService.tempPlace);
                          Navigator.push(context, RutaPersonalizada().rutaPersonalizada(IgluSelected()));
                          
                        } else {
                          Navigator.push(context, RutaPersonalizada().rutaPersonalizada(IgluSelected()));

                        }

                      }
                    }
                    ),
                profileServices.loadSelfie
                ? Container()
                : CupertinoDialogAction(
                    child: const Text('No me gusta'),
                    isDestructiveAction: true,
                    onPressed: () => Navigator.pop(context)
                    )
              ],
            );
          });
    }
  }


}

  @override
  Widget build(BuildContext context) {

    final newProfileService = Provider.of<NewProfileServices>(context);
    final user = Provider.of<ProfileServices>(context).newUser;

    return GestureDetector(
      onTap: () {        
        newProfileService.loadIdiomas(user.languages!);
        Navigator.pushNamed(context, 'home');
        
      },
      
      child: Column(
        children: [
          SvgPicture.asset('assets/icons/radar_white_24dp.svg',color: Colors.white, height: 25),
           const Text('Explorar', style: TextStyle(color: Colors.white),)
    
        ],
      ),
    );
  }


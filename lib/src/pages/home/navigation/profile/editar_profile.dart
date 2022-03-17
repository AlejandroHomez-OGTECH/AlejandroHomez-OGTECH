
import 'dart:async';
import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:icebreaking_app/src/models/models.dart';

import 'package:flutter/cupertino.dart';
import 'package:icebreaking_app/src/pages/home/navigation/profile/editar/editarfotos.dart';
import 'package:icebreaking_app/src/pages/home/navigation/profile/editar/editaridiomas.dart';

import 'package:icebreaking_app/src/pages/pages.dart';
import 'package:icebreaking_app/src/providers/formuser_provider.dart';
import 'package:icebreaking_app/src/providers/homeprovider.dart';
import 'package:icebreaking_app/src/services/newprofile_service.dart';
import 'package:icebreaking_app/src/services/profile_service.dart';
import 'package:icebreaking_app/src/styles/styles.dart';
import 'package:icebreaking_app/src/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditarProfile extends StatelessWidget {

    @override
    Widget build(BuildContext context) {
    
    final profileServices = Provider.of<ProfileServices>(context);

    return ChangeNotifierProvider(
      create: (_) => FormProfileProvider(profileServices.newUser),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                    children: [
                      _HeaderProfile(),
    
                      _EditarNombre(),
                      const SizedBox(height: 5),
                      const Divider(),

                      _EditarOtrosDatos(),
                      const SizedBox(height: 5),
                      const Divider(),
    
                      _EditarBiografia(),
                      const SizedBox(height: 5),
                      const Divider(),
    
                      _EditarGenero(),
                      const SizedBox(height: 5),
                      const Divider(),
    
                      _EditarInteres(),
                      const SizedBox(height: 5),
                      const Divider(),
    
                      _RangoEdad(),
                      const SizedBox(height: 5),
                      const Divider(),
    
                      _ComoSoy(),
                      const SizedBox(height: 5),
                      const Divider(),
    
                      _EditarLenguajes(),
                      const SizedBox(height: 5),
                      const Divider(),
    
                      _EditarMisFotos()
    
                      ],
                      
                    ),
                  ),
    
                      _BotonListo()
                ],
              ),
            )
      ),
    );
   }
}


class _BotonListo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final profileServices = Provider.of<ProfileServices>(context);
    final formProvider = Provider.of<FormProfileProvider>(context);

    return Positioned(
      top: 35,
      right: 10,
      child: GestureDetector(
        onTap: () {
            profileServices.setLoadUpdateIce = true;

            Timer(const Duration(seconds: 1), () async{

            final String? imgUrl = await profileServices.uploadImage(formProvider.user.email);

            if (imgUrl != null) {
              formProvider.updatePhotoProfile(imgUrl);
            }  

            profileServices.updateUserIce(formProvider.user);
            profileServices.newUser = formProvider.user;

            profileServices.setLoadUpdateIce = false;

            }); 


        },
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 500) ,
            curve: Curves.easeInOutBack,
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            height: 40,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      blurRadius: 10,
                      color: Colors.grey.shade300,
                      spreadRadius: 1)
                ],
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:  [
                profileServices.loadUpdateIce 
                ? Container(
                  margin: const EdgeInsets.only(right: 5),
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(color: MyStyles().colorRojo, strokeWidth: 2, ))
                : const Icon( Icons.check_circle, color: Colors.greenAccent, size: 22,),
                const SizedBox(width: 5),

                Text(profileServices.loadUpdateIce ? 'Guardando...' : 'Listo'),
              ],
            )),
      ),
    );
  }
}

class _HeaderProfile extends StatelessWidget {


  String dropdownvalue = 'Editar';

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final user = Provider.of<ProfileServices>(context).newUser;
    final fomruser = Provider.of<FormProfileProvider>(context).user;

    return Stack(
      children: [
        SizedBox(
          width: size.width,
          height: size.height * 0.3,
          child: ClipPath(
              clipper: CustomProfile(),
              child: Stack(
                children: [
                  
                  ImagenProfileBanner(user: fomruser),

                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      color: Colors.black45,
                    ),
                  ),
                ],
              )),
        ),

        Positioned(
            bottom: 0,
            child: SizedBox(
              width: size.width,
              child: Center(child: ImagenProfile(user: fomruser)),
            )),

        Positioned(
          bottom: 10,
          right: 10,
          child: Center(child: AddImageButton())),
        

        Positioned(
          top: 5,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.only(top: 30, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      final homeProvider =  Provider.of<HomeProvider>(context, listen: false);

                      homeProvider.setPaginaActual = 0;
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        size: 28, color: Colors.white)
                ),
              ],
            ),
          ),
        ),

      ],
    );
  }
}


//Editar en otra pagina
class _EditarOtrosDatos extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
     padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               const Text('Editar otros datos', style: TextStyle(fontSize: 23)),
               GestureDetector(
                 onTap:() => Navigator.pushReplacement(context, _RutaEditar()),
                 child: Text('Editar', style: TextStyle(fontSize: 15, color: MyStyles().colorRojo, fontFamily: 'Roboto2'))),

            ],
          ),
          const SizedBox(height:5),

          Text('Podras editar datos como tu interes, numero de telefono, profesión, ascendencia y agregar tus redes sociales.',
          style: TextStyle(color: Colors.grey.shade400, fontSize: 15, fontFamily: 'Roboto2'),
          maxLines: 3,
          )
        ],
      ),
    );
  }

  PageRouteBuilder<dynamic> _RutaEditar() {

    return PageRouteBuilder(
                          
                              pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secundaryAnimation) => const EditaOtros(),
                              transitionDuration: const Duration(milliseconds: 400),
                              transitionsBuilder: (context, animation , secundatyAnimation, child) {
                                
                                final curvedAnimation = CurvedAnimation(parent: animation, curve: Curves.easeIn);

                                return SlideTransition(
                                  position: Tween<Offset>(begin: const Offset(1.0, 0.0) , end: Offset.zero).animate(curvedAnimation),
                                  child: child,
                                  );
                              }   
                            );
  }
}

class _EditarMisFotos extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final profileServices = Provider.of<ProfileServices>(context);

    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Editar mis fotos', style: TextStyle(fontSize: 23)),
              GestureDetector(
                onTap: () {

                profileServices.listaPaths = [];
                  
                 Navigator.pushReplacement(context, _RutaEditar());
                },
                child: Text('Editar',
                    style: TextStyle(
                        fontSize: 15,
                        color: MyStyles().colorRojo,
                        fontFamily: 'Roboto2')),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            'Agrega tus mejores fotografias.',
            style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 15,
                fontFamily: 'Roboto2'),
            maxLines: 3,
          ),
          const SizedBox(height: 5),

          Row(
            children: [

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: 50,
                  height: 50,
                  decoration:  BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: const BorderRadius.all(Radius.circular(10)
                    )
                  ),
                  child: const Icon(Icons.add_a_photo_rounded, color: Colors.white)
                ), 

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: 50,
                  height: 50,
                  decoration:  BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius:const BorderRadius.all(Radius.circular(10)
                    )
                  ),
                  child: const Icon(Icons.add_a_photo_rounded,
                      color: Colors.white)

                ), 

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: 50,
                  height: 50,
                  decoration:  BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius:const BorderRadius.all(Radius.circular(10)
                    )
                  ),
                  child: const Icon(Icons.add_a_photo_rounded, color: Colors.white)
                ),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: 50,
                  height: 50,
                  decoration:  BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius:const BorderRadius.all(Radius.circular(10)
                    )
                  ),
                  child: const Icon(Icons.add_a_photo_rounded,
                      color: Colors.white)

                ),

            ],
          )
        ],
      ),
    );
  }

    PageRouteBuilder<dynamic> _RutaEditar() {

    return PageRouteBuilder(
                          
                pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secundaryAnimation) =>  EditarFotos(),
                transitionDuration: const Duration(milliseconds: 400),
                transitionsBuilder: (context, animation , secundatyAnimation, child) {
                  
                  final curvedAnimation = CurvedAnimation(parent: animation, curve: Curves.easeIn);

                  return SlideTransition(
                    position: Tween<Offset>(begin: const Offset(1.0, 0.0) , end: Offset.zero).animate(curvedAnimation),
                    child: child,
                    );
                }   
              );
  }
}

class _EditarBiografia extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final formProvider = Provider.of<FormProfileProvider>(context);
    final user = Provider.of<ProfileServices>(context).newUser;

    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Editar Biografia', style: TextStyle(fontSize: 23)),
          const SizedBox(height: 5),
          Form(
            child: TextFormField(

            initialValue:  user.biography,
            style:const TextStyle(color: Colors.black, fontFamily: 'Roboto2', fontSize: 15),
            maxLines: 10,
            keyboardType: TextInputType.multiline,
            cursorColor: MyStyles().colorRojo,
            autocorrect: true,
            decoration: const InputDecoration(
              errorStyle:  TextStyle(color: Colors.red),
              contentPadding:  EdgeInsets.all(10),

              border:  OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(width: 2, color: Colors.grey)),

              focusedBorder:  OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.red)),

              enabledBorder:  OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.grey)),

              hintText: 'Describe tu perfil en unas palabra, presume lo que mejor sabes hacer...',
              hintStyle:  TextStyle(color: Colors.black38),
                
            ),

            onChanged: (value) {
              formProvider.updateBiography(value);
              }
            ),

                    

          )
        ],
      ),
    );
  }
}

class _EditarLenguajes extends StatelessWidget {

  @override
  Widget build(BuildContext context) {


    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Editar tus idiomas', style: TextStyle(fontSize: 23)),
              GestureDetector(
                onTap: () => Navigator.pushReplacement(context, _RutaEditar()),
                child: Text('Editar',
                    style: TextStyle(
                        fontSize: 15,
                        color: MyStyles().colorRojo,
                        fontFamily: 'Roboto2')),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            'Podras agregar los idiomas que manejas para que tu perfil sea mas interesante.',
            style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 15,
                fontFamily: 'Roboto2'),
            maxLines: 2,
          )
        ],
      ),
    );
  }

   PageRouteBuilder<dynamic> _RutaEditar() {

    return PageRouteBuilder(
                          
                pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secundaryAnimation) => EditarIdiomas(),
                transitionDuration: const Duration(milliseconds: 400),
                transitionsBuilder: (context, animation , secundatyAnimation, child) {
                  
                  final curvedAnimation = CurvedAnimation(parent: animation, curve: Curves.easeIn);

                  return SlideTransition(
                    position: Tween<Offset>(begin: const Offset(1.0, 0.0) , end: Offset.zero).animate(curvedAnimation),
                    child: child,
                    );
                }   
              );
  }
}

//Nombre y Correo
class _EditarNombre extends StatelessWidget {

  late String edad;

  String getEdad(UserIce user){

   DateTime fecha = user.dateOfBirth.toDate();
   DateTime hoy = DateTime.now();

   edad = (hoy.year - fecha.year).toString();

  return edad;
  }

  @override
  Widget build(BuildContext context) {

  final user = Provider.of<ProfileServices>(context).newUser;
  final formProvider = Provider.of<FormProfileProvider>(context);


    return Container(
      margin: const EdgeInsets.only(top: 50),
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              const Divider(),
              const SizedBox(height: 5),
        
              //Nombre
              const Text('Editar Nombre', style: TextStyle(fontSize: 23)),
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                    Colors.white,
                    Colors.grey.shade100,
                  ])
                ),
                child: TextFormField(
                  style:const TextStyle(color: Colors.black, fontFamily: 'Roboto2', fontSize: 15),
                  initialValue: user.fullName,
                  keyboardType: TextInputType.name,
                  cursorColor: MyStyles().colorRojo,
                  autocorrect: false,
                  decoration: InputDecorationEditar.decorationInput(
                    iconData: Icons.person,
                    context: context, 
                    hinText: '', 
                    labelTex: ''),
                onChanged: (value) {
                  formProvider.updateName(value);
                },
                 validator: (value) {
                  return (value != null && value.length >= 5)
                      ? null
                      : 'Ingrese un valor con mas de 5 caracteres';
                },         
                ),
              ),
 

          ],
        ),
      ),
    );
  }
}


//Genero
class _EditarGenero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Editar Genero', style: TextStyle(fontSize: 23)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            width: size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ItemGenero(index: 0, texto: 'Hombre'),
                _ItemGenero(index: 1, texto: 'Mujer'),
                _ItemGenero(index: 2, texto: 'No binario'),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _ItemGenero extends StatelessWidget {
  final int index;
  final String texto;

  _ItemGenero({required this.index, required this.texto});

  @override
  Widget build(BuildContext context) {

  final newProfileService = Provider.of<NewProfileServices>(context);
  final formProvider = Provider.of<FormProfileProvider>(context);

    if (newProfileService.genero == index) {

      return FadeInDown(
        from: 5,
        child: AnimatedContainer(
          margin: const EdgeInsets.symmetric(vertical: 5),
          height: 50,
          duration: const Duration(milliseconds: 100),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              border: Border.all(
                  color: Colors.transparent
                      ),
              gradient: LinearGradient(colors: [
                 MyStyles().colorAzul,
                 MyStyles().colorRojo,
              ])),
          child: Text(texto,
              style: const TextStyle( color: Colors.white )),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        newProfileService.setGenero = index;
        formProvider.updateGenero(index);
      },
      child: AnimatedContainer(
        margin: const EdgeInsets.symmetric(vertical: 5),
        height: 50,
        duration: const Duration(milliseconds: 100),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            border: Border.all(
                color: Colors.black,
                width: 0.5),
            gradient:const LinearGradient(colors: [
                  Colors.white,
                  Colors.white,
            ])),
        child: Text(texto,
            style:const TextStyle(
                color: Colors.black)),
      ),
    );
  }
}


//Que Busco
class _EditarInteres extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Editar mi interes', style: TextStyle(fontSize: 23)),
          Container(
            margin: const EdgeInsets.all(5),
            width: size.width,
            height: 150,
            child: GridView.count(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: false,
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 3,
              children: [
                _ItemInteres(index: 0, texto: 'Hombres'),
                _ItemInteres(index: 1, texto: 'Mujeres'),
                _ItemInteres(index: 2, texto: 'Queer'),
                _ItemInteres(index: 3, texto: 'Trans'),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _ItemInteres extends StatelessWidget {
  
  final int index;
  final String  texto;

  // ignore: prefer_const_constructors_in_immutables
  _ItemInteres({required this.index, required this.texto});

  @override
  Widget build(BuildContext context) {

    final newProfileService = Provider.of<NewProfileServices>(context);
    final formProvider = Provider.of<FormProfileProvider>(context);


    // ignore: unrelated_type_equality_checks
    if (formProvider.user.interest == texto ) {

       return FadeInDown(
         from: 5,
         child: AnimatedContainer(
           duration: const Duration(milliseconds: 100),
           alignment: Alignment.center,
           decoration: BoxDecoration(
               borderRadius: const BorderRadius.all(Radius.circular(20)),
               border: Border.all(
                   color: Colors.transparent
                      ),
               gradient: LinearGradient(colors: [
                  MyStyles().colorAzul ,
                  MyStyles().colorRojo ,
               ])),
           child: Text(texto,
               style:const TextStyle(
                   color: Colors.white
                       )),
         ),
       );
      
    }

    return GestureDetector(
      onTap: () {
        newProfileService.setinteres = index;
        formProvider.updateInterest(texto);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        alignment: Alignment.center,
          decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(color: Colors.black),
          gradient: const LinearGradient(colors: [
             Colors.white,
             Colors.white,
          ])
        ),
        child: Text(texto, style: const TextStyle(color: Colors.black)),
      ),
    );
  }
}


//Rango de edad
class _RangoEdad extends StatefulWidget {
  @override
  State<_RangoEdad> createState() => _RangoEdadState();
}

class _RangoEdadState extends State<_RangoEdad> {
  List<int> listaNumeros = [];

  @override
  void initState() {
    lista();
    super.initState();
  }

  void lista() {
    for (var i = 18; i < 81; i++) {
      listaNumeros.add(i);
    }
    listaNumeros.length;
  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<ProfileServices>(context).newUser;
    final formProvider = Provider.of<FormProfileProvider>(context);

    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Editar rango de edad', style: TextStyle(fontSize: 23)),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text('Desde', style: MyStyles().subtitleStyle1),

                  DropdownButton<int>(
                      underline: Container(
                        height: 2,
                        color: MyStyles().colorAzul,
                      ),
                      alignment: Alignment.bottomCenter,
                      menuMaxHeight: 500,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      elevation: 2,
                      icon: const Icon(Icons.format_list_numbered),
                      hint: const Text('Desde'),
                      value: user.edadRangeDesde,
                      onChanged: (value) {
                        setState(() {
                          user.edadRangeDesde = value!;
                          formProvider.updateAgeRangeDesde(value);
                        });
                      },
                      items: listaNumeros.map((edadDesde) {
                        return DropdownMenuItem(
                            child: Center(child: Text('$edadDesde')),
                            value: edadDesde);
                      }).toList()),
                ],
              ),
              Column(
                children: [
                  Text('Hasta', style: MyStyles().subtitleStyle1),
                  DropdownButton<int>(
                      underline: Container(
                        height: 2,
                        color: MyStyles().colorRojo,
                      ),
                      alignment: Alignment.bottomCenter,
                      menuMaxHeight: 500,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      elevation: 2,
                      icon: const Icon(Icons.format_list_numbered),
                      hint: const Text('Desde'),
                      value: user.edadRangeHasta,
                      onChanged: (value) {
                        setState(() {
                          user.edadRangeHasta = value!;
                          formProvider.updateAgeRangeHasta(value);
                        });
                      },
                      items: listaNumeros.map((edadHasta) {
                        return DropdownMenuItem(
                            child: Center(child: Text('$edadHasta')),
                            value: edadHasta);
                      }).toList()),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}


//Como soy
class _ComoSoy extends StatefulWidget {

  @override
  State<_ComoSoy> createState() => _ComoSoyState();
}

class _ComoSoyState extends State<_ComoSoy> {

  double valorComosoy = 0.0;

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<ProfileServices>(context).newUser;
    final formProvider = Provider.of<FormProfileProvider>(context);

   double numero =  user.howAmI.toDouble();

    return Container(
      padding: const EdgeInsets.all(10),
      height: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text('Editar como soy', style: TextStyle(fontSize: 23)),
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Timido', style: MyStyles().subtitleStyle,),
                Text('Lanzado', style: MyStyles().subtitleStyle,),
              ],
            ),
          ),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Text('0'),
                Expanded(
                  child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackShape: const GradientRectSliderTrackShape(),
                      ),
                      child: Slider( 
                        activeColor: MyStyles().colorRojo,
                        inactiveColor: Colors.grey.shade300,
                        label: '${valorComosoy.toInt()}',
                        min: 0,
                        max: 10,
                        value: formProvider.validarprogreso == 0 
                        ? numero 
                        : valorComosoy,
                        onChanged: (double value) {
                          setState(() {
                            formProvider.setValidarprogreso = 1;
                            valorComosoy = value;
                            formProvider.updateHowAmI(value.toInt());
                          });
                        },
                      )),
                ),
                Text( formProvider.validarprogreso == 0 
                ? numero.toInt().toString() 
                : valorComosoy.toInt().toString()),
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class AddImageButton extends StatefulWidget {
  @override
  _AddImageButtonState createState() => _AddImageButtonState();
}

class _AddImageButtonState extends State<AddImageButton> {
  double _height = 0;

  @override
  Widget build(BuildContext context) {

    final formProvider = Provider.of<FormProfileProvider>(context);
    final profileServices = Provider.of<ProfileServices>(context);


    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
  
        GestureDetector(
          onTap: () {
            const  altura = 75.0;

            setState(() {
              if (_height == 0) {
                _height = altura;
              } else {
                _height = 0;
              }
            });
          },
          child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15,
                      offset: Offset(0, 12))
                ], 
                color: Colors.white, 
                shape: BoxShape.circle),
                child: ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (rect) {
                      return MyStyles()
                          .gradientHorizontal
                          .createShader(rect);
                    },
                    child: const Icon(Icons.add_circle_sharp, size: 30)
                )
              )
        ),

        AnimatedContainer(
          margin: const EdgeInsets.only(left: 40),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutQuart,
          height: _height,
          padding:const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10)
            ),
             
          child: SingleChildScrollView(
            child: Column(
              children: [
        
                GestureDetector(
                    onTap: () async {
                      setState(() {
                        _height = 0.0;
                      });
        
                      final _imagePicker =  ImagePicker();

                      final XFile? photo = await _imagePicker.pickImage(
                        source: ImageSource.camera,
                        imageQuality: 50,
                      );
        
                      if (photo == null) {
                        print('No selecciono nada');
                        return;
                      }
                        print('Tenemos imagen ${photo.path}');

                     formProvider.updatePhotoProfile(photo.path);
                     profileServices.updateSelectedImage(photo.path);

                   
                    },
                    child:Container(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      alignment: Alignment.center,
                      width: 90,
                      decoration: BoxDecoration(
                        color: MyStyles().colorRojo,
                        borderRadius: const BorderRadius.all(Radius.circular(5))
                      ),
                      child: const Text('Camara', style: TextStyle(color: Colors.white))
                    )
                  ),
        
                const SizedBox(height: 5),
        
                GestureDetector(
                    onTap: () async {
                      
                      setState(() {
                        _height = 0.0;
                      });
        
                      final picker =  ImagePicker();
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 100,
                          );
        
                      if (image == null) {
                         print('No selecciono nada');
                        return;
                      }

                      print('Tenemos imagen ${image.path}');

                     formProvider.updatePhotoProfile(image.path);
                     profileServices.updateSelectedImage(image.path);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      alignment: Alignment.center,
                      width: 90,
                      decoration: BoxDecoration(
                        color: MyStyles().colorRojo,
                        borderRadius: const BorderRadius.all(Radius.circular(5))
                      ),
                      child: const Text('Galeria',  style: TextStyle(color: Colors.white))))
              ],
            ),
          ),
        ),
      ],
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:icebreaking_app/src/models/banderas.dart';

import 'package:icebreaking_app/src/pages/pages.dart';
import 'package:icebreaking_app/src/providers/formuser_provider.dart';
import 'package:icebreaking_app/src/services/newprofile_service.dart';
import 'package:icebreaking_app/src/services/services.dart';
import 'package:icebreaking_app/src/styles/styles.dart';


import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';


class EditarIdiomas extends StatelessWidget {

   PageRouteBuilder<dynamic> _RutaEditar() {
    return PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secundaryAnimation) => EditarProfile(),
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secundatyAnimation, child) {
          final curvedAnimation =
              CurvedAnimation(parent: animation, curve: Curves.easeIn);

          return SlideTransition(
            position:
                Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero)
                    .animate(curvedAnimation),
            child: child,
          );
        });
  }

  @override
  Widget build(BuildContext context) {

    final profileServices = Provider.of<ProfileServices>(context);

    return ChangeNotifierProvider(
      create: (_) => FormProfileProvider(profileServices.newUser),
      child: Scaffold(
    
        appBar: AppBar(
          elevation: 1,
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          title: const Text('Editar idiomas'),
          leading: IconButton(
            onPressed:() => Navigator.pushReplacement(context, _RutaEditar()),
            icon: const Icon(Icons.arrow_back_ios_outlined)),
          actions: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: _BotonListo(),
            )
          ],
        ),
    
        body: Stack(
          children: [
            SingleChildScrollView(
              physics:  const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _EditarIdiomas(),
                ],
              ),
            ),
            // _BotonListo()

          ],
        ),
      ),
    );
  }
}



class _BotonListo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final profileServices = Provider.of<ProfileServices>(context);
    final formProvider = Provider.of<FormProfileProvider>(context);

    return GestureDetector(
      onTap: () {
        profileServices.setLoadUpdateIce = true;

        Timer(const Duration(seconds: 2), () {
          profileServices.updateUserIce(formProvider.user);
          profileServices.newUser = formProvider.user;
          profileServices.setLoadUpdateIce = false;
        });
      },
      child: AnimatedContainer(
          color: Colors.white,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutBack,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(right: 10),
          alignment: Alignment.center,
          height: 35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              profileServices.loadUpdateIce
                  ? Container(
                      margin: const EdgeInsets.only(right: 5),
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: MyStyles().colorRojo,
                        strokeWidth: 2,
                      ))
                  : const Icon(
                      Icons.check_circle,
                      color: Colors.greenAccent,
                      size: 22,
                    ),
              const SizedBox(width: 5),
              Text(profileServices.loadUpdateIce ? 'Guardando...' : 'Listo'),
            ],
          )),
    );
  }
}

class _EditarIdiomas extends StatelessWidget {

  List<Bandera> banderas = listBanderas();

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final newProfileService = Provider.of<NewProfileServices>(context);

    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tus idiomas', style: TextStyle(fontSize: 23)),
          const SizedBox(height: 5),

           AnimatedContainer(
            duration: const Duration(seconds: 1),
            width: double.infinity,
            height: newProfileService.misIdiomas.length <= 2 
            ? size.height * 0.08 
            : newProfileService.misIdiomas.length >= 3 && newProfileService.misIdiomas.length <= 4 
              ? size.height * 0.15 
              : newProfileService.misIdiomas.length >= 5 && newProfileService.misIdiomas.length <= 6
                  ? size.height * 0.22 
                  : size.height * 0.3,


            child: newProfileService.misIdiomas.isEmpty 
              ? ZoomIn(child: Center(child: Text('Aun no tienes idiomas', style: MyStyles().subtitleStyle1,)))
              : GridView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: newProfileService.misIdiomas.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3 / 1,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 5),
                  itemBuilder: (context, index) {
            
                    return ItemMisIdiomas(index: index, bandera: newProfileService.misIdiomas[index]);                
                }),
          ),

          const Divider(),
        
          const SizedBox(height: 5),
          const Text('Elige los idiomas que manejas', style: TextStyle(fontSize: 23)),
          const SizedBox(height: 5),

          SizedBox(
            width: double.infinity,
            height: newProfileService.misIdiomas.length <= 2
                ? size.height * 0.68
                : newProfileService.misIdiomas.length >= 3 &&newProfileService.misIdiomas.length <= 4
                    ? size.height * 0.6
                     : newProfileService.misIdiomas.length >= 5 && newProfileService.misIdiomas.length <= 6
                        ? size.height * 0.53 
                        : size.height * 0.45,

                    
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: banderas.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 3 / 1,
                crossAxisSpacing: 20,
                mainAxisSpacing: 5),
                itemBuilder: (context, index) {
          
                  return ItemIdioma(index: index, bandera: banderas[index]);                
              }),
          )
        ],
      ),
    );
  }
}

class ItemIdioma extends StatelessWidget {

  final int index;
  final Bandera bandera;

  ItemIdioma({required this.index, required this.bandera});

  bool comparar( Bandera bandera , BuildContext context) {

  bool existe = false;
  final newProfileService = Provider.of<NewProfileServices>(context);

  for (var i = 0; i < newProfileService.misIdiomas.length ; i++) {

      if (bandera.idioma == newProfileService.misIdiomas[i].idioma) {
        existe = true;
      }

  }
  return existe;

  }

  @override
  Widget build(BuildContext context) {

    final newProfileService = Provider.of<NewProfileServices>(context);
    final formProvider = Provider.of<FormProfileProvider>(context);

    if (newProfileService.idioma == index ) {

      return FadeInDown(
        from: 5,
        child: GestureDetector(
          onTap: () {
            newProfileService.agregarIdioma(bandera);
            formProvider.updateLanguages(newProfileService.idiomasaGuardar);
          },
          child: AnimatedContainer(
            margin: const EdgeInsets.symmetric(vertical: 5),
            height: 50,
            duration: const Duration(milliseconds: 100),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                border: Border.all(
                    color: Colors.transparent),
                gradient: LinearGradient(colors: [
                  MyStyles().colorAzul.withOpacity(0.2),
                   MyStyles().colorRojo.withOpacity(0.2)
                      
                ])),
            child: Row(
              children: [
        
                Container(
                  margin: const EdgeInsets.all(10),
                  width: 30,
                  child: FadeInImage(
                    placeholder: const AssetImage('assets/loading.gif'), 
                    image: NetworkImage(bandera.bandera),
                    ),
                ),
        
                Text(bandera.idioma, style: const TextStyle(color: Colors.black)),
              ],
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        newProfileService.setIdioma = index;
        newProfileService.agregarIdioma(bandera);
        formProvider.updateLanguages(newProfileService.idiomasaGuardar);
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
            gradient: const LinearGradient(colors:  [
               Colors.white,
               Colors.white,
            ])),

        child: Row(
          children: [
            Container(
               margin: const EdgeInsets.all(10),
              width: 30,
              child: FadeInImage(
                  placeholder: const AssetImage('assets/loading.gif'),
                  image: NetworkImage(bandera.bandera),
                  ),
            ),
            Text(bandera.idioma, style: const TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }
}


class ItemMisIdiomas extends StatelessWidget {

  final int index;
  final Bandera bandera;

  ItemMisIdiomas({required this.index, required this.bandera});

  @override
  Widget build(BuildContext context) {

    final newProfileService = Provider.of<NewProfileServices>(context);
    final formProvider = Provider.of<FormProfileProvider>(context);

    return GestureDetector(

      onTap: () {
        newProfileService.eliminarIdioma(bandera);
        formProvider.updateLanguages(newProfileService.idiomasaGuardar);
      },

      child: FadeInUp(
        from: 5,
        child: AnimatedContainer(
          margin: const EdgeInsets.symmetric(vertical: 5),
          height: 50,
          duration: const Duration(milliseconds: 100),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              gradient: LinearGradient(colors:  [
                    MyStyles().colorAzul.withOpacity(0.2),
                   MyStyles().colorRojo.withOpacity(0.2)
              ])),
      
          child: Row(
            children: [
              Container(
                 margin: const EdgeInsets.all(10),
                width: 30,
                child: FadeInImage(
                    placeholder: const AssetImage('assets/loading.gif'),
                    image: NetworkImage(bandera.bandera),
                    ),
              ),
              Text(bandera.idioma, style: const TextStyle(color: Colors.black)),
            ],
          ),
        ),
      ),
    );
  }
}


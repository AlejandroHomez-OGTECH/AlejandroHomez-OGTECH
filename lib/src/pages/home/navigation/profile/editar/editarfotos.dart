import 'dart:async';

import 'package:flutter/material.dart';
import 'package:icebreaking_app/src/pages/pages.dart';
import 'package:icebreaking_app/src/providers/formuser_provider.dart';
import 'package:icebreaking_app/src/services/services.dart';
import 'package:icebreaking_app/src/styles/styles.dart';
import 'package:icebreaking_app/src/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';

class EditarFotos extends StatelessWidget {
  
  PageRouteBuilder<dynamic> _RutaEditar() {
    return PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secundaryAnimation) =>
            EditarProfile(),
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
          title: const Text('Editar mis fotos'),
          leading: IconButton(
              onPressed: () =>
                  Navigator.pushReplacement(context, _RutaEditar()),
              icon: const Icon(Icons.arrow_back_ios_outlined)),
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Center(child: _PhotosPage()),

            Padding(
              padding: const EdgeInsets.all(25),
              child: SizedBox(
                width: 150,
                child: _BotonListo()),
            )
          ],
        ),
      ),
    );
  }
}

class _BotonListo extends StatelessWidget {

    PageRouteBuilder<dynamic> _RutaEditar() {
    return PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secundaryAnimation) =>
            EditarProfile(),
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
    final formProvider = Provider.of<FormProfileProvider>(context);

    return GestureDetector(
      onTap: () async {
        profileServices.setLoadUpdateIce = true;

   
             List<String>? imgUrls = await profileServices.uploadImagesList(formProvider.user.email);
            final List<String>? formimgs = formProvider.user.myPictures;

            List<String> nuevalista = [];
            profileServices.listaPaths = [];

            for (var h = 0; h < formimgs!.length; h++) {
                if (formimgs[h].startsWith('http')) {
                    nuevalista.add(formimgs[h]);
                }
            }

              if (formimgs.isNotEmpty && imgUrls != null) {
                for (var i = 0; i < imgUrls.length; i++) {
                      if (imgUrls[i].startsWith('http')) {
                        nuevalista.add(imgUrls[i]);
                      }
                    }
              }
            

            if (imgUrls != null) {
              formProvider.updateMyPictures(nuevalista);
            }

              profileServices.updateUserIce(formProvider.user);
              profileServices.newUser = formProvider.user;
              profileServices.setLoadUpdateIce = false;

              Navigator.pushReplacement(context, _RutaEditar());

        },
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutBack,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(right: 10),
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 10)
            ],
            borderRadius: BorderRadius.all(Radius.circular(10)
          ))
          ,
          height: 35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
                      size: 18,
                    ),
              const SizedBox(width: 5),
              Text(profileServices.loadUpdateIce ? 'Guardando...' : 'Listo'),
            ],
          )),
    );
  }
}

class _PhotosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<FormProfileProvider>(context).user;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal:  10, vertical: 10),
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: 8,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 3 / 2.6,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
        itemBuilder: (context, index) {
          
        int valor;

              valor = user.myPictures!.length - 1;

              if (user.myPictures!.isEmpty || index > valor) {

                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          child: Container(
                              padding: const EdgeInsets.all(10),
                              color: Colors.grey.shade200,
                              child: Opacity(
                                  opacity: 0.2,
                                  child: Image.asset(
                                      'assets/logo_fondo_blanco.png')))),
                    ),
                    AddImageButton()
                  ],
                );
              }

              return Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                        child: ImagenLista(
                          foto: user.myPictures![index],
                        )),
                  ),

                  _BotonEliminar(user.myPictures![index])
                ],
              );  

        })
      );
  }
}

class _BotonEliminar extends StatelessWidget {

final String imagen;
_BotonEliminar(this.imagen); 

  @override
  Widget build(BuildContext context) {

    final formProvider = Provider.of<FormProfileProvider>(context);
    final profileServices = Provider.of<ProfileServices>(context);


    return GestureDetector(
      onTap: () {
        formProvider.user.myPictures!.remove(imagen);

        List<String>? lista = formProvider.user.myPictures;

      
        formProvider.updateMyPictures(lista!);

        if (imagen.startsWith('/data')) {
          profileServices.listaPaths.remove(imagen);
        }

      },
      child: Container(
        margin: const EdgeInsets.all(5),
        width: 25,
        height: 25,
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle
        ),
        child: const Icon(Icons.remove, color: Colors.white),
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
      alignment: Alignment.topCenter,
      children: [
  
        GestureDetector(
          onTap: () {
            const  altura = 85.0;

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
                      color: Colors.black12,
                      blurRadius: 10,
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
          margin: const EdgeInsets.only(top: 38),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutQuart,
          height: _height,
          padding:const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10)
            ),
             
          child: GestureDetector(
              onTap: () async {
                setState(() {
                  _height = 0.0;
                });
        
                final _imagePicker =  ImagePicker();

                final List<XFile>? photos = await _imagePicker.pickMultiImage(
                  imageQuality: 50
                );
        
                if (photos == null) {
                  print('No selecciono nada');
                  return;
                } else {

                  print('Tenemos imagenes ${photos.length}');

                  List<String> lista = formProvider.user.myPictures!; 
                  List<String>? listaPaths =   profileServices.updateSelectedImages(lista, photos);
                  formProvider.updateMyPictures(listaPaths!);

                }
                  
    
              },
              child:Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                alignment: Alignment.center,
                width: 90,
                decoration: BoxDecoration(
                  color: MyStyles().colorRojo,
                  borderRadius: const BorderRadius.all(Radius.circular(5))
                ),
                child: const Text('Galeria', style: TextStyle(color: Colors.white))
              )
            ),
        ),
      ],
    );
  }
}

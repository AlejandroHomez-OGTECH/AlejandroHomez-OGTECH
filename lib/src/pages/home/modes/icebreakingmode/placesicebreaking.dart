import 'dart:io';
import 'dart:ui';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icebreaking_app/src/models/models.dart';
import 'package:icebreaking_app/src/models/places.dart';
import 'package:icebreaking_app/src/pages/home/modes/icebreakingmode/iglu_selected.dart';
import 'package:icebreaking_app/src/providers/providers.dart';
import 'package:icebreaking_app/src/services/services.dart';
import 'package:icebreaking_app/src/styles/styles.dart';
import 'package:icebreaking_app/src/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PlacesIcebreaking extends StatefulWidget {

  @override
  State<PlacesIcebreaking> createState() => _PlacesIcebreakingState();
}

class _PlacesIcebreakingState extends State<PlacesIcebreaking> {

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    ThemeData.light();  
    
   final profileServices = Provider.of<ProfileServices>(context);
   final placeService = Provider.of<PlaceService>(context);
   
    
    return ChangeNotifierProvider(
      create: (_) => FormProfileProvider(profileServices.newUser),
      child: Scaffold(
        body: Stack(
              children: [
                _CardList(),
        
                _Header(),
        
                Positioned(
                  bottom: 0,
                  left: 0,
                  right:0,
                  child: SizedBox(
                          width: 500,
                          height: 80,
                          child: NavigationBarIcBreaking(null),
                        ),
              ),
          
              ],
            ),
      )
    );
  }
}


class _CardList extends StatefulWidget {
  
  @override
  State<_CardList> createState() => _CardListState();
}

class _CardListState extends State<_CardList> {

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final placeService = Provider.of<PlaceService>(context);

    List<Place> listPlaces = placeService.showPlaces;

      return   Container(
              padding: const EdgeInsets.only(top: 80, bottom: 80),
              width: size.width ,
              height: size.height,
              child:  listPlaces.isNotEmpty     
              ? Swiper(
                layout: SwiperLayout.STACK,
                itemWidth: size.width * 0.9,
                itemHeight: size.height * 0.7,
                pagination: SwiperPagination(
                  margin: const EdgeInsets.only(bottom: 0),
                  alignment: Alignment.bottomCenter,
                  builder: DotSwiperPaginationBuilder(
                      activeColor: MyStyles().colorRojo,
                      color: Colors.grey,
                      ),
                ),
                itemCount: listPlaces.length,
                itemBuilder: (context , index) => ItemCardList(index, listPlaces[index]) )
                
            : Container(
              padding: const EdgeInsets.only(top: 80, bottom: 80),
              width: size.width ,
              height: size.height,
              child: const Center(child: Text('No hay lugares cerca de tu ubicacion actual')
              ))
          );
        }
}

class ItemCardList extends StatelessWidget {

  final Place place;
  final int index;
  ItemCardList(this.index, this.place);

  @override
  Widget build(BuildContext context) {

    final placeService = Provider.of<PlaceService>(context);
    final profileServices = Provider.of<ProfileServices>(context);
    final formProvider = Provider.of<FormProfileProvider>(context);

    final size = MediaQuery.of(context).size;

    return Stack(
      children: [

        Container(
          margin: const EdgeInsets.all(25),
          width: size.width * 0.8,
          height: size.height * 0.6,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft:Radius.circular(0) ,
              bottomRight:Radius.circular(22) ,
              topLeft:Radius.circular(22) ,
              topRight:Radius.circular(0) 
            ),
            image: DecorationImage(image: NetworkImage('https://img.freepik.com/foto-gratis/mesa-madera-vistas-al-interior-habitacion-desenfocada_1048-11830.jpg?size=626&ext=jpg'),
            fit: BoxFit.cover
            )
          ),
          child: Stack(
            children: [
              
              Container(
                decoration:const BoxDecoration(
                   borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(22),
                        topLeft: Radius.circular(22),
                        topRight: Radius.circular(0)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.center,
                    colors: [
                    Colors.black,
                    Colors.transparent
                  ])
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center ,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [

                     Text( place.name , 
                     style:TextStyle(
                       color: Colors.white, 
                       fontSize: place.name.length > 10 ? 25 : 35)),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (rect) {
                              return MyStyles().gradientDiagonal.createShader(rect);
                            },
                            child: const Icon(Icons.location_on))
                        ),
                       const Text('place', style: TextStyle(color: Colors.white, fontSize: 16))
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius:const BorderRadius.all(Radius.circular(100)),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                              child: Container(
                                padding: const EdgeInsets.all(30),
                                width: 200,
                                height: 200,  
                                decoration: const BoxDecoration(
                                color: Colors.white60,
                                borderRadius: BorderRadius.all(Radius.circular(100))
                                ),
                                child: Image.asset('assets/copa.png',height: 150,),
                              ),
                            ),
                          ),
                          Text(place.type, 
                                style:TextStyle(
                                  color: Colors.white, 
                                  fontSize: place.type.length > 10 ? 25 : 30)
                                )
                        ],
                      ),
                    )
                    
                    
                     ],
                ),
              ),
            ],
          ) ,
        ),

        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: GestureDetector(
            onTap: () async {

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

                await formProvider.updateSelfiePhoto(selfiePhoto.path);
                 profileServices.updateSelectedSelfiePhoto(selfiePhoto.path);

                addSelfiePhoto(context);


            },
            child: Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 5, offset: Offset(0.0, 5)
                  )
                ],
                image: DecorationImage(image: AssetImage('assets/llamas.png'))
              ),
            ),
          ),
        )
      ],
    );
  }

    void addSelfiePhoto(BuildContext context) {
    final formProvider = Provider.of<FormProfileProvider>(context, listen: false);
    final profileServices =Provider.of<ProfileServices>(context, listen: false);
    final placeService = Provider.of<PlaceService>(context, listen: false);

    if (Platform.isAndroid) {

      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: const Text('Foto para ingresar a un Iglu',
                  textAlign: TextAlign.center),
              content: SelfiePhoto(user: formProvider.user),
              actions: [
                profileServices.loadSelfie == false
                    ? MaterialButton(
                        elevation: 5,
                        child: const Text('Cancelar'),
                        textColor: MyStyles().colorRojo,
                        onPressed: () => Navigator.pop(context))
                    : Container(),
                MaterialButton(
                  elevation: 5,
                  textColor: MyStyles().colorRojo,
                  onPressed: profileServices.loadSelfie
                      ? null
                      : () async {
                          Navigator.pop(context);

                          profileServices.setLoadSelfie = true;

                          final String? selfeUrl = await profileServices
                              .uploadSelfiePhoto(formProvider.user.email);

                          if (selfeUrl != null) {
                            formProvider.updateSelfiePhoto(selfeUrl);
                          }

                          profileServices.updateUserIce(formProvider.user);
                          profileServices.newUser = formProvider.user;

                          profileServices.setLoadSelfie = false;

                          placeService.tempPlace = place;

                          if (placeService.tempPlace.users == null) {

                            List<String> lista = [];

                            lista.add(formProvider.user.id!);
                            placeService.tempPlace.users = lista;
                            placeService.updatePlaceIce(placeService.tempPlace);

                            Navigator.push(
                                context,
                                RutaPersonalizada()
                                    .rutaPersonalizada(IgluSelected()));
                          } else {

                            List<String> lista = placeService.tempPlace.users!;

                            bool repetido = false;

                            for (var i = 0; i < lista.length; i++) {
                              if (formProvider.user.id! == lista[i]) {
                                repetido = true;
                              }
                            }

                            if (repetido == false) {

                              lista.add(formProvider.user.id!);
                              placeService.tempPlace.users = lista;
                              placeService.updatePlaceIce(placeService.tempPlace);


                              
                              Navigator.push(
                                  context,
                                  RutaPersonalizada()
                                      .rutaPersonalizada(IgluSelected()));
                            } else {


                              Navigator.push(
                                  context,
                                  RutaPersonalizada()
                                      .rutaPersonalizada(IgluSelected()));
                            }
                          }
                        },
                  child: Text(profileServices.loadSelfie
                      ? 'Cargando selfie...'
                      : 'Me gusta esta foto'),
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
                    child: Text(profileServices.loadSelfie
                        ? 'Cargando selfie...'
                        : 'Me gusta esta foto'),
                    isDefaultAction: true,
                    onPressed: profileServices.loadSelfie
                        ? null
                        : () async {
                            Navigator.pop(context);

                            profileServices.setLoadSelfie = true;

                            final String? selfeUrl = await profileServices
                                .uploadSelfiePhoto(formProvider.user.email);
                            if (selfeUrl != null) {
                              formProvider.updateSelfiePhoto(selfeUrl);
                            }

                            profileServices.updateUserIce(formProvider.user);
                            profileServices.newUser = formProvider.user;

                            profileServices.setLoadSelfie = false;

                            placeService.tempPlace = place;

                            if (placeService.tempPlace.users == null) {
                              List<String> lista = [];

                              lista.add(formProvider.user.id!);
                              placeService.tempPlace.users = lista;
                              placeService
                                  .updatePlaceIce(placeService.tempPlace);
                              Navigator.push(
                                  context,
                                  RutaPersonalizada()
                                      .rutaPersonalizada(IgluSelected()));
                            } else {
                              List<String> lista =
                                  placeService.tempPlace.users!;
                              bool repetido = false;

                              for (var i = 0; i < lista.length; i++) {
                                if (formProvider.user.id! == lista[i]) {
                                  repetido = true;
                                }
                              }

                              if (repetido == false) {
                                lista.add(formProvider.user.id!);
                                placeService.tempPlace.users = lista;
                                placeService
                                    .updatePlaceIce(placeService.tempPlace);
                                Navigator.push(
                                    context,
                                    RutaPersonalizada()
                                        .rutaPersonalizada(IgluSelected()));
                              } else {
                                Navigator.push(
                                    context,
                                    RutaPersonalizada()
                                        .rutaPersonalizada(IgluSelected()));
                              }
                            }
                          }),
                profileServices.loadSelfie
                    ? Container()
                    : CupertinoDialogAction(
                        child: const Text('No me gusta'),
                        isDestructiveAction: true,
                        onPressed: () => Navigator.pop(context))
              ],
            );
          });
    }
  }

}

class _Header extends StatefulWidget {

  @override
  State<_Header> createState() => _HeaderState();
}

class _HeaderState extends State<_Header> {

  bool isLoad = false;

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final placeServices = Provider.of<PlaceService>(context);


    return SizedBox(
      width: size.width,
      height: size.height * 0.14,
      child: Stack(
        alignment: Alignment.center,
        children: [

          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: CustomPaint(
              painter: CustomIceBreakingModeIglus(),
            ),
          ),

           Positioned(
            top: 30,
            child:SizedBox(
              width: 350,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  const SizedBox(width: 50),

                  const Text('Cerca de ti', style: TextStyle(color: Colors.white, fontSize: 30)),
                
                  IconButton(onPressed: isLoad 
                  ? null
                  : () async {
      
                      setState(() {
                        isLoad = true;
                      });

                    await  placeServices.loadShowPlacesIce();

                      setState(() {
                       isLoad = false;
                      });

                  }
                  , icon: isLoad 
                    ? CircularProgressIndicator(
                      strokeWidth: 3,
                      backgroundColor: Colors.white,
                      color: MyStyles().colorAzul,
                    )
                    : const Icon(FontAwesomeIcons.redoAlt, color: Colors.white,))
                ],
              ),
            )
            ),
      
          // _SelfiePhoto(),


        ],
      ),
    );
  }
}

class _SelfiePhoto extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    final formProvider = Provider.of<FormProfileProvider>(context);

    return Positioned(
      top: 38,
      right: 12,
      child: Container(
        width: 95,
        height: 95,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(formProvider.user.selfiePhoto!),
            fit: BoxFit.cover
            )
        ),
      ),
    );
  }
}
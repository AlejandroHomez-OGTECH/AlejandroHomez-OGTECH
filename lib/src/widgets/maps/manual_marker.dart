import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:icebreaking_app/src/models/models.dart';
import 'package:icebreaking_app/src/pages/pages.dart';
import 'package:icebreaking_app/src/services/services.dart';
import 'package:icebreaking_app/src/styles/styles.dart';
import 'package:icebreaking_app/src/widgets/route.dart';
import 'package:provider/provider.dart';

class ManualMarker extends StatelessWidget {

  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final placeService = Provider.of<PlaceService>(context);

    return SizedBox(
      width: size.width,
      height: size.height  * 0.7,
      child: Stack(
        children: [

          Positioned(
            left: 15,
            top: 0,
            child: _ButtomBack()
            ),

          Center(
            child: Transform.translate(
              offset: const Offset(0, -13),
              child: BounceInDown(
                child: ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (rect) => MyStyles().gradientRedToOrange.createShader(rect),
                  child: const Icon(Icons.place_rounded, size: 35)
                ),
              ),
            ),
          ),


          Positioned(
            bottom: 45,
            left: 50,
            right: 50,
            child: FadeInUp(
              duration: const Duration(milliseconds: 300),
              child: MaterialButton(
                minWidth: size.width - 150,
                onPressed: placeService.isLoadingHome
                ? null
                : () async {
 
                final position = await Geolocator.getCurrentPosition();

                placeService.setIsLoadingHome = true;
                  Place place = Place(

                    id: '',
                    name: '', 
                    location: '${position.latitude},${position.longitude}',
                    type: 'Lugar',
                    users: []
                    );

                  placeService.newPlace = place;

                 placeService.setIsLoadingHome = false;

                  Navigator.push(context, RutaPersonalizada().rutaPersonalizada(CreateMarkerPage()));
                },
                height: 50,
                color: Colors.transparent,
                elevation: 0,
                focusElevation: 0,
                hoverElevation: 0,
                highlightElevation: 0,
                disabledElevation: 0,
                disabledColor: Colors.grey.shade200,
                padding: const EdgeInsets.all(0),
                shape: const StadiumBorder(),
                child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      decoration: BoxDecoration(
                          gradient: placeService.isLoadingHome
                              ? const LinearGradient(
                                  colors: [Colors.grey, Colors.grey])
                              : MyStyles().gradientRedToOrange,
                          borderRadius: const BorderRadius.all(Radius.circular(10))),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 10),
                      child: Text(
                        placeService.isLoadingHome ? 'Cargando' : 'Confirmar ubicación',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      )
                ),
                ),
            )
          )
        ],
      ),
    );
  }
}

class _ButtomBack extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final markerService = Provider.of<MarkerProvider>(context);

    return FadeInLeft(
      duration: const Duration(milliseconds: 300),
      child: CircleAvatar(
        backgroundColor: Colors.black,
        maxRadius: 25,
        child: IconButton(
          onPressed: () => markerService.setShowMarkerUi = false,
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          
        ),
      ),
    );
  }
}
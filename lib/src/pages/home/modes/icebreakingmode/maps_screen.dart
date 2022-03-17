import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icebreaking_app/src/blocs/blocs.dart';
import 'package:icebreaking_app/src/services/place_service.dart';
import 'package:icebreaking_app/src/services/services.dart';
import 'package:icebreaking_app/src/styles/styles.dart';
import 'package:icebreaking_app/src/widgets/maps/manual_marker.dart';
import 'package:icebreaking_app/src/widgets/maps/map_view.dart';
import 'package:provider/provider.dart';
import 'package:avatar_glow/avatar_glow.dart';

class MapScreen extends StatefulWidget {

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  late LocationBloc locationBloc;

  @override
  void initState() {
    super.initState();

    locationBloc = BlocProvider.of<LocationBloc>(context);
    locationBloc.starFollowingUser();

  }

  @override
  void dispose() {
    locationBloc.stopFlollowingUser();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    // final placeService = Provider.of<PlaceService>(context);
    final markerService = Provider.of<MarkerProvider>(context);


    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, state) {

        if (state.lastKnownLocation == null) {
          return const Center(child: Text('Espere por favor...'));
        }

        return  SingleChildScrollView(
          child: Stack(
            alignment: Alignment.center,
            children: [
              MapView(initialLocation: state.lastKnownLocation!), 

              markerService.showMarkerUi
              ? ManualMarker()
              : _ButtomCreateMarker()
            ],
          ),
        );
      },
    );
  }
}

class _ButtomCreateMarker extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final markerService = Provider.of<MarkerProvider>(context);


    return SizedBox(
      width: size.width,
      height: size.height * 0.71,
      child: Stack(
        children: [   


           AnimatedOpacity(
             duration: const Duration(seconds: 3),
             curve: Curves.easeInQuint,
             opacity: 1.0,
             child: Center(
              child: AvatarGlow(
                glowColor: Colors.blue,
                endRadius: 110.0,
                duration:const Duration(milliseconds: 3000),
                repeat: true,
                showTwoGlows: true,
                repeatPauseDuration:const Duration(milliseconds: 0),
                child: Pulse(
                  infinite: true,
                  animate: true,
                  child: const Material(
                    elevation: 8.0,
                    shape: CircleBorder(),
                    child:  Icon(Icons.circle, size: 15, color: Colors.blue,)),
                ),
              ),
                     ),
           ), 
          
          Positioned(
            top: 0,
            left: 15,
            child: FadeInLeft(
              duration: const Duration(milliseconds: 300),
              child: InkWell(
                onTap: () =>  markerService.setShowMarkerUi = true,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration:  BoxDecoration(
                        color: Colors.white54,
                        shape: BoxShape.circle,
                        border: Border.all(color: MyStyles().colorNaranja)                   ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (rect) => MyStyles().gradientHorizontal.createShader(rect),
                            child: const Icon(Icons.place, size: 30,),
                            ),
                            const Text('Crear')
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
           ),
        ]
      )
    );
  }
}

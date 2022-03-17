import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:icebreaking_app/src/blocs/blocs.dart';
import 'package:icebreaking_app/src/models/models.dart';
import 'package:icebreaking_app/src/services/services.dart';
import 'package:icebreaking_app/src/styles/styles.dart';
import 'package:provider/provider.dart';

class MapView extends StatelessWidget {

  final LatLng initialLocation;

  // ignore: use_key_in_widget_constructors
  const MapView({
    required this.initialLocation
  });

  @override
  Widget build(BuildContext context) {

    final mapBloc = BlocProvider.of<MapBloc>(context);

    final CameraPosition initialCameraPosition = CameraPosition(
      target: initialLocation,
      zoom: 20,
    );

    final size = MediaQuery.of(context).size;
    final placeState = Provider.of<PlaceService>(context);

    return FutureBuilder(
      future: placeState.loadPlacesIce(),
      builder: (context, AsyncSnapshot<List<Place>> snap) {

         if (snap.data == null) {
            return SizedBox(
              width: size.width,
              height: size.height * 0.75,
              child: Center(
                    child: CircularProgressIndicator(
                  backgroundColor: MyStyles().colorAzul,
                  color: MyStyles().colorRojo,
                )
              ),
            );
            
          }

        placeState.loadShowPlacesIce();    

        return SizedBox(
        width: size.width,
        height: size.height * 0.75,
        child: GoogleMap(
          initialCameraPosition: initialCameraPosition,
          myLocationEnabled: false,
          zoomControlsEnabled: false,
          tiltGesturesEnabled: false,
          scrollGesturesEnabled: false,
          mapType: MapType.normal,
          markers: placeState.markers.toSet() ,
          onMapCreated: (controller) => mapBloc.add( OnMapInitializedEvent(controller) )
         ),
        );
      }
    );
  }
}
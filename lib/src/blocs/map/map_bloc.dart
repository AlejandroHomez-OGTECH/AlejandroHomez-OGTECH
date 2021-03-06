
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:icebreaking_app/src/blocs/blocs.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {

  LocationBloc locationBloc;
  
  GoogleMapController? _mapController;

  MapBloc({
    required this.locationBloc
  }) : super(const MapState()) {

    on<OnMapInitializedEvent>( _onInitMap );

    locationBloc.stream.listen(( locationState ) {

      if ( !state.followUser) return;
      if ( locationState.lastKnownLocation == null ) return;

      moveCamera(locationState.lastKnownLocation!);

    });
  }

  void _onInitMap(OnMapInitializedEvent event, Emitter<MapState> emit){
   _mapController = event.controller;

  //  _mapController!.setMapStyle( jsonEncode( iterfaceMapTheme ) );

   emit(state.copyWith(isMapInitialized: true));

  }

  void moveCamera(LatLng newLocation){
    final cameraUpdate = CameraUpdate.newLatLng( newLocation );
    _mapController?.animateCamera(cameraUpdate);
  }

}

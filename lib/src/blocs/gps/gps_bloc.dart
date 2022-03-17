import 'dart:async';

import 'package:permission_handler/permission_handler.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

part 'gps_event.dart';
part 'gps_state.dart';

class GpsBloc extends Bloc<GpsEvent, GpsState> {

  StreamSubscription? gpsServiceSubscription;

  GpsBloc() : super(const GpsState(isGpsEnable: false, isGpsPermissionGranted: false)) {
    
    on<GpsAndPermissionEvent>((event, emit) => emit( state.copyWith(
      isGpsEnable: event.isGpsEnable,
      isGpsPermissionGranted: event.isGpsPermissionGranted
    ))
  );

  _init();

  }

  Future<void> _init() async {

     final gpsInitStatus = await Future.wait([

       _checkGpsStatus(),
       _isPermissionGranted()

     ]);

     add(GpsAndPermissionEvent(
       isGpsEnable: gpsInitStatus[0], 
       isGpsPermissionGranted: gpsInitStatus[1]
      ));

  }

  Future<bool> _isPermissionGranted() async {

    final isGranted = await Permission.location.isGranted;
    return isGranted;

  }

  Future<bool> _checkGpsStatus() async {

    final isenable = await Geolocator.isLocationServiceEnabled();

    gpsServiceSubscription = Geolocator.getServiceStatusStream().listen((event) { 

      final isEnable = ( event.index == 1 ) ? true : false;
      add(GpsAndPermissionEvent(
       isGpsEnable: isEnable, 
       isGpsPermissionGranted: state.isGpsPermissionGranted
      ));

    });

    return isenable;
  }


  Future<void> askGpsAcces() async {

    final status = await Permission.location.request();

    switch (status) {
   
      case PermissionStatus.granted:
        add(GpsAndPermissionEvent(isGpsEnable: state.isGpsEnable, isGpsPermissionGranted: true));
        break;
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.denied:
        add(GpsAndPermissionEvent(isGpsEnable: state.isGpsEnable, isGpsPermissionGranted: false));
      openAppSettings();
    }

  }


  @override
  Future<void> close() {
    gpsServiceSubscription?.cancel();
    return super.close();
  }

}

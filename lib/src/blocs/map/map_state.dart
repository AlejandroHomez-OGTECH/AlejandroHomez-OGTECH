part of 'map_bloc.dart';

 class MapState extends Equatable {

   final bool isMapInitialized;
   final bool followUser;


   final Map<String, Marker> markers;

  const MapState({
     this.isMapInitialized = false, 
     this.followUser =  true,
     Map<String, Marker>? markers
     }) : markers = markers ?? const {};


  MapState copyWith({

    bool? isMapInitialized ,
    bool? followUser,
    Map<String, Marker>? markers

  }) => MapState(
    isMapInitialized : isMapInitialized ?? this.isMapInitialized,
    followUser       : followUser ?? this.followUser,
    markers          : markers ?? this.markers

  );
  
  @override
  List<Object> get props => [isMapInitialized, followUser, markers];
}


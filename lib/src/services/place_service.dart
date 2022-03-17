import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:icebreaking_app/src/models/models.dart';
import 'package:icebreaking_app/src/widgets/CustomsPainters/custom_marker.dart';

import 'dart:ui' as ui;

class PlaceService  extends ChangeNotifier {


  late Place tempPlace;
  List<Place> places = [];
  List<Place> showPlaces = [];
  List<Marker> markers = [];
  bool _isLoading = false;
  bool _isLoadingHome = false;


  late Place newPlace;

  int lengthShowPlaces = 0; 

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool get isLoadingHome => _isLoadingHome;
   set setIsLoadingHome(bool value) {
    _isLoadingHome = value;
    notifyListeners();
  }


  updateUsersPlace(List<String> users) {
    tempPlace.users = users;
    notifyListeners();
  }

  Future<String> createplaceIce(Place place) async {
    await FirebaseFirestore.instance.collection('places_icebreaking').add({
      'id'        : '',
      'name'      : place.name,
      'location'  : place.location,
      'type'      : place.type,
      'users'     : place.users
    });

    Place placeLoad = await loadSinglePlaceIce();
    updatePlaceIce(placeLoad);
    tempPlace = place;
    return place.name;

  }
 
  Future<String> updatePlaceIce(Place place) async {

    await FirebaseFirestore.instance
        .collection('places_icebreaking')
        .doc(place.id)
        .set({  
      'id'       : place.id,
      'name'     : place.name,
      'location' : place.location,
      'type'     : place.type,
      'users'    : place.users

    });
    return place.name;
  }

  Future<Place> loadSinglePlaceIce() async {
    
    await FirebaseFirestore.instance
        .collection('places_icebreaking')
        .orderBy('id')
        .get()
        .then((QuerySnapshot value) {

        Place place = Place(
          id: value.docs[0].id,
          name: value.docs[0]["name"],
          type: value.docs[0]["type"],
          location: value.docs[0]["location"],
          users: List<String>.from(value.docs[0]["users"].map((x) => x)),

        );
        
        tempPlace = place;
        notifyListeners();
    });

    notifyListeners();

    return tempPlace;
  }

  Future<Place> reloadPlaceSelected() async {
    
    await FirebaseFirestore.instance
        .collection('places_icebreaking')
        .where('id', isEqualTo: tempPlace.id)
        .get()
        .then((QuerySnapshot value) {

        Place place = Place(
          id: value.docs[0].id,
          name: value.docs[0]["name"],
          type: value.docs[0]["type"],
          location: value.docs[0]["location"],
          users: List<String>.from(value.docs[0]["users"].map((x) => x)),

        );
        
        tempPlace = place;
        notifyListeners();
    });

    notifyListeners();
    return tempPlace;
  }

  Future<List<Place>> loadPlacesIce() async {

    await FirebaseFirestore.instance
        .collection('places_icebreaking')
        .orderBy('name')
        .get()
        .then((QuerySnapshot value)  {

      if (value.docs.length == places.length) {
        return places;
      }
      
      int i = 0;
      places.clear();
      
      while ( i < value.docs.length ) {

         Place place = Place(
          id: value.docs[i].id,
          name: value.docs[i]["name"],
          type: value.docs[i]["type"],
          location: value.docs[i]["location"],
          users:  List<String>.from(value.docs[i]["users"].map((x) => x)),
         
        );
        places.add(place);
        i++;
        
      }
       loadMarkes(places); 
    });

    notifyListeners();
    return places;
  }

  Future<List<Place>> loadShowPlacesIce() async {

    final position = await Geolocator.getCurrentPosition();

    await FirebaseFirestore.instance
        .collection('places_icebreaking')
        .orderBy('name')
        .get()
        .then((QuerySnapshot value)  {

   principal :  for (var i = 0; i < value.docs.length; i++) {

         List<String> latlong = value.docs[i]["location"].split(',').toList();
          double lat = double.parse(latlong[0]);
          double long = double.parse(latlong[1]);

          double distance = (3959 *
            acos(cos(position.latitude) *
                    cos(lat) *
                    cos(long - position.longitude) +
                sin(position.latitude) * sin(lat))
        );

        if (distance < 0.2) {
          bool repetido = false;

          if (showPlaces.isNotEmpty) {

            for (var h = 0; h < showPlaces.length; h++) {
                if (showPlaces[h].id == value.docs[i].id) {
                  repetido = true;
                }
              }

            if (repetido == false) {

              Place place = Place(
                id: value.docs[i].id,
                name: value.docs[i]["name"],
                type: value.docs[i]["type"],
                location: value.docs[i]["location"],
                users: List<String>.from(value.docs[i]["users"].map((x) => x)),
              );
              showPlaces.add(place);
              notifyListeners();
            }
            
          } else {

             Place place = Place(
              id: value.docs[i].id,
              name: value.docs[i]["name"],
              type: value.docs[i]["type"],
              location: value.docs[i]["location"],
              users: List<String>.from(value.docs[i]["users"].map((x) => x)),
            );
            showPlaces.add(place);
            notifyListeners();

          }

          if (i == value.docs.length) {
            break principal;
          }

        }

      }
    });
    notifyListeners();
    return showPlaces;
  }

  Future<List<Marker>> loadMarkes(List<Place> placesLoad) async {

    if (markers.length == placesLoad.length) {
      return markers;
    }

    markers.clear();
    
    for (var i = 0; i < placesLoad.length ; i++) {

      if (markers.length <= placesLoad.length) {

       BitmapDescriptor markerDraw = await capturePng(placesLoad[i].name,

        placesLoad[i].type);

        List<String> latlong = placesLoad[i].location.split(',').toList();
        double lat = double.parse(latlong[0]);
        double long = double.parse(latlong[1]);

        Marker marker = Marker(
            visible: true,
            anchor: const Offset(0.1, 1),
            markerId: MarkerId(placesLoad[i].id!),
            position: LatLng(lat, long),
            icon: markerDraw);

        markers.add(marker);
        
      }
    }

    return markers;
   }

  Future<BitmapDescriptor> capturePng(String name, String type) async {

    final recoder = ui.PictureRecorder();
    final canvas = ui.Canvas(recoder);
    const size = ui.Size(330, 200);

    final markerDraw = CustomMarker(name: name, type: type);
    markerDraw.paint(canvas, size);

    final picture = recoder.endRecording();
    final image = await picture.toImage(size.width.toInt(), size.height.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);


    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }

}

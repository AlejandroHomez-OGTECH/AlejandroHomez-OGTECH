
import 'package:flutter/material.dart';

class MarkerProvider extends ChangeNotifier {

  bool _showMarkerUi = false;
  


  bool get showMarkerUi => _showMarkerUi;
  set setShowMarkerUi(bool value ) {
    _showMarkerUi =  value;
    notifyListeners();
  }

}
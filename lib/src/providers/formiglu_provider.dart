import 'package:flutter/material.dart';
import 'package:icebreaking_app/src/models/models.dart';

class FormIgluProvider extends ChangeNotifier {
  
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Place place;

  FormIgluProvider(this.place);

  int _validarprogreso = 0;

  int get validarprogreso => _validarprogreso;
  set setValidarprogreso(int value) {
    _validarprogreso = value;
    notifyListeners();
  }


  updateName(String value) {
    place.name = value;
    notifyListeners();
  }

  updateType(String value) {
    place.type = value;
    notifyListeners();
  }

  updateUsersList(List<String> value) {
    place.users = value;
    notifyListeners();
  }

  updateLocation(String value) {
    place.location = value;
    notifyListeners();
  }


  bool isvalidForm() {
    return formKey.currentState?.validate() ?? false;
  }

}

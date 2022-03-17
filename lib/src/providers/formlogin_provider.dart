import 'package:flutter/material.dart';

class FormLoginProvider extends ChangeNotifier {

  GlobalKey<FormState> formKey =  GlobalKey<FormState>();
  GlobalKey<FormState> formKey2 = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String name = '';

  bool _isLoading = false;
  int _lenghText = 0;

  bool showPassword = true;
  bool _correoValidator = false;

  bool get correoValidator => _correoValidator;
  int  get lengthText => _lenghText;

  set setLentghText(int lenght) {
    _lenghText = lenght;
    notifyListeners();
  }


  set setCorreoValidator(bool correoValidartor) {
    print(_lenghText);

    _correoValidator = correoValidartor;
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  set isLoading (bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool showPassWord(){

    if (showPassword == false) {
      showPassword = true;
      notifyListeners();
      return showPassword;
    }

    if (showPassword == true){
      showPassword = false;
      notifyListeners();
     return showPassword;
    }

    return showPassword;

  }
  

  bool isvalidForm(){
    return formKey.currentState?.validate() ?? false;
  }

  bool isvalidForm2() {
    return formKey2.currentState?.validate() ?? false;
  }

}
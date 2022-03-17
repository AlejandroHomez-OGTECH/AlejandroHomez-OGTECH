import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsurario  {

  static final PreferenciasUsurario _instancia = PreferenciasUsurario._internal();

  factory PreferenciasUsurario() {
    return _instancia;
  }

  PreferenciasUsurario._internal();

  late SharedPreferences _prefs;

  initPref() async {
    _prefs = await SharedPreferences.getInstance();
  }

  //primeravez

  get primeraVez {
    return _prefs.getBool('primeravez') ?? true;
  }
  set setPrimeravez(bool valor) {
    _prefs.setBool('primeravez', valor);
  }


  //Email
  get email {
    return _prefs.getString('email');
  }
  set setEmail(String valor) {
    _prefs.setString('email', valor);
  }

}

import 'package:flutter/material.dart';
import 'package:icebreaking_app/src/models/banderas.dart';

class NewProfileServices extends ChangeNotifier {

  final PageController _pageController = PageController();

  int _queBusco = 0;
  int _idioma = 0;
  int _interes = 0;
  int _genero = 0;
  int _paginaActual = 0;
  double _porcentaje = 0.0;

  List<Bandera> misIdiomas = [];
  List<String>  idiomasaGuardar = [];

  PageController get pageController => _pageController;


  Future<void> agregarIdioma(Bandera bandera) async {

    bool existe = false;

    for (var i = 0; i < misIdiomas.length; i++) {
      if (bandera.idioma == misIdiomas[i].idioma) {
        existe = true;
      }
    }

    if (existe == false) {
    misIdiomas.add(bandera);
    idiomasaGuardar.add(bandera.idioma);
    notifyListeners();
    }
    
  }

   Future<void> eliminarIdioma(Bandera bandera) async {
    misIdiomas.remove(bandera);
    idiomasaGuardar.remove(bandera.idioma);
    notifyListeners();
  }

   Future<List<Bandera>> loadIdiomas(List<String> banderas) async {


    misIdiomas = [];
    List<Bandera> lista = listBanderas();
    final int dato = banderas.length - 1;
    int contador = 0; 

     if (banderas.length == misIdiomas.length) {
      return misIdiomas;
     }

      while (contador <= dato) {

             for (var i = 0; i < lista.length; i++) {

                if (lista[i].idioma == banderas[contador]) {
                misIdiomas.add(lista[i]);
                contador++;
                break;
              }
            
          }
            
        
        } // wh
    return misIdiomas;
  }

  
  int get paginaActual => _paginaActual;

  set setPaginaActual(int valor) {
    _paginaActual = valor;
    _pageController.animateToPage(valor,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutBack);

     switch (_paginaActual) { 
       case 0:{ setPorcentaje = 0.0; }break;

       case 1: { setPorcentaje = 0.4; } break;

       case 2:  { setPorcentaje = 0.8; }break;
     }

    notifyListeners();
  }

  double get porcentaje => _porcentaje;

  set setPorcentaje(double value) {
    _porcentaje = value;
    notifyListeners();
  }

  int get queBusco => _queBusco;

  set setQueBuco(int value) {
  _queBusco = value;
  notifyListeners();
  }  

  int get genero => _genero;

  set setGenero(int value) {
    _genero = value;
    notifyListeners();
  }  

  int get interes => _interes;

  set setinteres(int value) {
    _interes = value;
    notifyListeners();
  } 

  int get idioma => _idioma;

  set setIdioma(int value) {
    _idioma = value;
    notifyListeners();
  }  
}

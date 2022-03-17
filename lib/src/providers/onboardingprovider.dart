import 'package:flutter/material.dart';

class OnBoardingProvider extends  ChangeNotifier{

  final PageController _pageController = PageController();

  int _paginaActual = 0;

  PageController get pageController => _pageController;

  int get paginaActual => _paginaActual;

  set setPaginaActual(int valor) {
    _paginaActual = valor;
    _pageController.animateToPage(valor,
        duration: const Duration(milliseconds: 500), curve: Curves.easeOutBack);

    notifyListeners();
  }

}
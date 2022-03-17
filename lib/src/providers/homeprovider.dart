import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier{

    final PageController _pageController = PageController();
    final PageController _pageControllerIce = PageController();
    
    int _paginaActual = 0;
    int _paginaActualIce = 0;

    PageController get pageController => _pageController;
    PageController get pageControllerIce => _pageControllerIce;

    int get paginaActual => _paginaActual;
    int get paginaActualIce => _paginaActualIce;

    set setPaginaActual(int valor) {
      _paginaActual = valor;
      _pageController.animateToPage(valor,
          duration: const Duration(milliseconds: 500), curve: Curves.easeOutBack);

      notifyListeners();
    }

      set setPaginaActualIce(int page) {
    _paginaActualIce = page;
    _pageControllerIce.animateToPage(page,
          duration: const Duration(milliseconds: 200), curve: Curves.easeOutBack);

    notifyListeners();
  }

}
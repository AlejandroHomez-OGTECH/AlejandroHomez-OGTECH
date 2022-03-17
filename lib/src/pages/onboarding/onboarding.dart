import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icebreaking_app/src/preferencias/preferencias_usuario.dart';
import 'package:icebreaking_app/src/providers/onboardingprovider.dart';

import 'package:icebreaking_app/src/styles/styles.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: use_key_in_widget_constructors
class OnBoardingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _FondoPantalla(
          child: SafeArea(
            child: Column(
              children: [
          
                _Titulo(),
                _PageIndicator(),
                _Pages()

              ],
            ),
          ),
      ),
    );
  }
}


//Pages
class _Pages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final onBoardingProvider = Provider.of<OnBoardingProvider>(context);

    return Expanded(
        child: PageView(
      physics:
          const BouncingScrollPhysics(parent: NeverScrollableScrollPhysics()),
      controller: onBoardingProvider.pageController,
      onPageChanged: (page) => onBoardingProvider.setPaginaActual = page,
      children: [
        OnBoardingPag(
            '¡Llegó la forma más sencilla de conectar con las personas cerca de ti!',
            1),
        OnBoardingPag(
            'Un encuentro, una charla, una amistad, ¿Por qué no algo más...?',
            2),
        OnBoardingPag('No seas tímido y ¡ROMPE EL HIELO!', 3),
      ],
    ));
  }
}

class OnBoardingPag extends StatefulWidget {

  
  final String text;
  final int index;
  OnBoardingPag(this.text, this.index);
  
  @override
  State<OnBoardingPag> createState() => _OnBoardingPagState();
}

class _OnBoardingPagState extends State<OnBoardingPag> {

  bool _primeravez = true;

  @override
  void initState() {
    _setPrimeraVez(_primeravez);
    super.initState();
  }

   _setPrimeraVez(bool valor) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('primeravez', valor);
    _primeravez = valor;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final onBoardingProvider = Provider.of<OnBoardingProvider>(context);

      final pref = PreferenciasUsurario();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
      child: Column(
        children: [
          const Spacer(),
          Text(widget.text,
              style: const TextStyle(color: Colors.white, fontSize: 22),
              maxLines: 3,
              textAlign: TextAlign.center),
          const SizedBox(height: 25),
          GestureDetector(
            onTap: () {
              onBoardingProvider.setPaginaActual = widget.index;

              if (widget.index == 3) {
                Navigator.pushReplacementNamed(context, 'login');
                _setPrimeraVez(false);
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              alignment: Alignment.center,
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  gradient: MyStyles().gradientRedToOrange
                  
                  ),
              child: Text(widget.index == 3 ? 'Vamos!!!' : 'Siguiente',
                  style: const TextStyle(color: Colors.white, fontSize: 22)),
            ),
          )
        ],
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          _PointIndicator(index: 0),
          _PointIndicator(index: 1),
          _PointIndicator(index: 2),  
        ],
      ),
    );
  }
}

class _PointIndicator extends StatelessWidget {
  final int index;

  _PointIndicator({required this.index});

  @override
  Widget build(BuildContext context) {

    final onBoardingProvider = Provider.of<OnBoardingProvider>(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInBack,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      width: onBoardingProvider.paginaActual == index ? 23 : 12,
      height: 12,
      decoration:  BoxDecoration(
        color: onBoardingProvider.paginaActual == index ? MyStyles().colorRojo : Colors.black,
        borderRadius: const BorderRadius.all(Radius.circular(20))
      ),
    );
  }
}



//Titulo

class _Titulo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {


    final onBoardingProvider = Provider.of<OnBoardingProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row( 
        children: [
          
          onBoardingProvider.paginaActual > 0
          ? _Regresar()
          : _vacio(),

          const Spacer(),
          Image.asset('assets/logo_fondo_blanco.png', width: 35),
          const SizedBox(width: 10),
          const Text('Ice Breaking', style: 
          TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -1),
          )
        ],
      ),
    );
  }

  Container _vacio() {
    return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.all(16),
          color: Colors.transparent,
          child: const Text(''),
        );
  }
}

class _Regresar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final onBoardingProvider = Provider.of<OnBoardingProvider>(context);

    int index = onBoardingProvider.paginaActual - 1;

    return ElasticIn(
      child: GestureDetector(
        onTap: () => onBoardingProvider.setPaginaActual = index,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              gradient: MyStyles().gradientVertical
                  ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (rect) {
                  return LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [MyStyles().colorAzul, MyStyles().colorRojo])
                      .createShader(rect);
                },
                child: const Icon(Icons.arrow_back_ios_rounded, size: 25)),
          ),
        ),
      ),
    );
  }
}


//Fondo
class _FondoPantalla extends StatelessWidget {

  final Widget child;
  // ignore: prefer_const_constructors_in_immutables
  _FondoPantalla({required this.child});

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        alignment: Alignment.center, 
        children: [ 
          Image.asset('assets/fondo.jpg', width: double.infinity , height: double.infinity,fit: BoxFit.cover),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.center,
                colors: [
                Colors.black,
                Colors.transparent,
              ])
            ),
          ),
          child
        ],
      ),
    );
  }
}
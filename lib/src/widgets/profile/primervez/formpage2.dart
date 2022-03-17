import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:icebreaking_app/src/providers/formuser_provider.dart';
import 'package:icebreaking_app/src/services/newprofile_service.dart';
import 'package:icebreaking_app/src/styles/styles.dart';
import 'package:provider/provider.dart';

class FormPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.only(top: 25, left: 20, right: 20, bottom: 15),
      padding: const EdgeInsets.all(1.5),
      decoration:  BoxDecoration(

          gradient: MyStyles().gradientHorizontal,

          borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
         decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
        child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                    _Titulo(),
                    _MiInteres(),
                    _RangoEdad(),
                    // _MiInteres(),
                
                ],
              ),
            )),
      ),
    );
  }
}


class _Titulo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 155,
      child: Image.asset('assets/llamas.png', height: double.infinity),
    );
  }
}


//Edad
class _RangoEdad extends StatefulWidget {

  @override
  State<_RangoEdad> createState() => _RangoEdadState();
}

class _RangoEdadState extends State<_RangoEdad> {
  List<int> listaNumeros= [];
  int _edadDesdeSelect = 18;
  int _edadHastaSelect = 79;

  @override
  void initState() {
    lista();
    super.initState();
  }

  void lista() {
    for (var i = 18; i < 80; i++) {
      listaNumeros.add(i);
    }
    listaNumeros.length;
  }

  @override
  Widget build(BuildContext context) {

    final formProvider = Provider.of<FormProfileProvider>(context);

    return Column(
      children: [

        Text('Rango de Edad', style: MyStyles().titleNewProfileStyle),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            
            Column(
              children: [
                Text('Desde', style: MyStyles().subtitleStyle1),
                DropdownButton<int>(
                  underline: Container(
                    height: 2,
                    color: MyStyles().colorAzul,
                  ),
                  alignment: Alignment.bottomCenter,
                  menuMaxHeight: 500,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  elevation: 2,
                  icon: const Icon(Icons.format_list_numbered),
                  hint: const Text('Desde'),
                  value: _edadDesdeSelect,
                  onChanged: (value) {
                    setState(() {
                    _edadDesdeSelect = value!;
                    formProvider.updateAgeRangeDesde(value);
                    });
                  },
                  items: listaNumeros.map((edadDesde) {
                    return DropdownMenuItem(
                      child: Center(child: Text('$edadDesde')),
                      value: edadDesde);
                  }).toList()
                ),
              ],
            ),

            Column(
              children: [
                Text('Hasta', style: MyStyles().subtitleStyle1),
                DropdownButton<int>(
                  underline: Container(
                      height: 2,
                      color: MyStyles().colorRojo,
                    ),
                  alignment: Alignment.bottomCenter,
                  menuMaxHeight: 500,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  elevation: 2,
                  icon: const Icon(Icons.format_list_numbered),
                  hint: const Text('Desde'),
                  value: _edadHastaSelect,
                  onChanged: (value) {
                    setState(() {
                    _edadHastaSelect = value!;
                    formProvider.updateAgeRangeHasta(value);
                    });
                  },
                  items: listaNumeros.map((edadHasta) {
                    return DropdownMenuItem(
                      child: Center(child: Text('$edadHasta')),
                      value: edadHasta);
                  }).toList()
                ),
              ],
            )

          ],
        ),
      ],
    );
  }
}


//Que busco
class _MiInteres extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Text('Me interesan', style: MyStyles().titleNewProfileStyle),
          Container(
            margin: const EdgeInsets.all(5),
            width: size.width,
            height: 150,
            child: GridView.count(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: false,
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 3,
              children: [
                _ItemInteres(index: 0, texto: 'Hombres'),
                _ItemInteres(index: 1, texto: 'Mujeres'),
                _ItemInteres(index: 2, texto: 'Queer'),
                _ItemInteres(index: 3, texto: 'Trans'),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _ItemInteres extends StatelessWidget {
  
  final int index;
  final String  texto;

  // ignore: prefer_const_constructors_in_immutables
  _ItemInteres({required this.index, required this.texto});

  @override
  Widget build(BuildContext context) {

    final newProfileService = Provider.of<NewProfileServices>(context);
    final formProvider = Provider.of<FormProfileProvider>(context);


    if (newProfileService.interes == index ) {

       return FadeInDown(
         from: 5,
         child: AnimatedContainer(
           duration: const Duration(milliseconds: 100),
           alignment: Alignment.center,
           decoration: BoxDecoration(
               borderRadius: const BorderRadius.all(Radius.circular(20)),
               border: Border.all(
                   color: Colors.transparent
                       ),
               gradient: LinearGradient(colors: [
                 MyStyles().colorAzul ,
                 MyStyles().colorRojo ,
               ])),
           child: Text(texto,
               style: const TextStyle(
                   color: Colors.white
                      )),
         ),
       );
      
    }

    return GestureDetector(
      onTap: () {
        newProfileService.setinteres = index;
        formProvider.updateInterest(texto);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        alignment: Alignment.center,
          decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(color: Colors.black),
          gradient: const LinearGradient(colors: [
           Colors.white,
         Colors.white,
          ])
        ),
        child: Text(texto, style: const TextStyle(color: Colors.black)),
      ),
    );
  }
}

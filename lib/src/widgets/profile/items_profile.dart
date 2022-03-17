import 'package:flutter/material.dart';
import 'package:icebreaking_app/src/services/services.dart';
import 'package:icebreaking_app/src/styles/styles.dart';
import 'package:provider/provider.dart';


class ItemsProfile extends StatelessWidget {
  List<String>  lista = ['FOTOS', 'BIOGRAFIA' , 'OTROS ' , 'REDES SOCIALES' ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.only(top: 30),
      height: 35,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: lista.length,
        itemBuilder:(_, int index) => _Item(lista[index], index) ,
        ),
    );
  }
}


class _Item extends StatefulWidget {

  final String titulo;
  final int index;
  _Item(this.titulo, this.index);

  @override
  State<_Item> createState() => _ItemState();
}

class _ItemState extends State<_Item> with SingleTickerProviderStateMixin {

late AnimationController controller;
late Animation<double> sizeWidth;

@override
void initState() {
  controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
  sizeWidth = Tween(begin: 0.0 , end: 100.0).animate(controller);
  super.initState();
}

@override
  void dispose() {
    controller.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {

  final profileService = Provider.of<ProfileServices>(context);

  controller.forward();


    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: GestureDetector(
        onTap: () {
          controller.reset();
          profileService.paginaActual = widget.index;
          controller.forward();
        },
        child: Container(
          child: Column(
            children: [
              Text(widget.titulo, textAlign: TextAlign.center,),
              const SizedBox(height: 5),
              AnimatedContainer(
                    duration: controller.duration!,
                    height: 2,
                    width: sizeWidth.value,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        profileService.itemSeleccionado == widget.index ? MyStyles().colorAzul : Colors.transparent,
                        profileService.itemSeleccionado == widget.index ? MyStyles().colorRojo : Colors.transparent,
                      ])
                    ),
                  )
            ],
          ),
        ),
      ),
    );
  }
}
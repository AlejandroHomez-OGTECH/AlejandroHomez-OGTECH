import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:icebreaking_app/src/pages/home/homepage.dart';
import 'package:icebreaking_app/src/providers/formiglu_provider.dart';
import 'package:icebreaking_app/src/services/place_service.dart';
import 'package:icebreaking_app/src/services/services.dart';
import 'package:icebreaking_app/src/styles/styles.dart';
import 'package:icebreaking_app/src/widgets/CustomsPainters/customregistro.dart';
import 'package:icebreaking_app/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

class CreateMarkerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final placeService = Provider.of<PlaceService>(context);

    return ChangeNotifierProvider(
      create: (_) => FormIgluProvider(placeService.newPlace),
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                _HeaderProfile(),
                _FormNewMarker()
              
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FormNewMarker extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

  final formProvider = Provider.of<FormIgluProvider>(context);


    return Form(
      key: formProvider.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
            _TitlePage(),
            const SizedBox(height: 30),
            _NameIglu(),
            const Divider(),
            _TipoLugar(),
            const Divider(),
            _Location(),
            const Divider(),
            const SizedBox(height: 50,),
            _Buttom()            

        ],
      ));
  }
}

class _Buttom extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

  final formProvider = Provider.of<FormIgluProvider>(context);
  final placeService = Provider.of<PlaceService>(context);
  final markerService = Provider.of<MarkerProvider>(context);


    return  FadeInUp(
            from: 10,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: MaterialButton(
                onPressed: placeService.isLoading
                    ? null
                    : () async {

                      FocusScope.of(context).unfocus();

                      if (!formProvider.isvalidForm()) return;
                      
                      placeService.isLoading = true;

                      placeService.places.clear();
                      placeService.markers.clear();

                      await placeService.createplaceIce(formProvider.place);
                      await placeService.loadPlacesIce();

                      markerService.setShowMarkerUi = false;
                      placeService.isLoading = false;

                      Navigator.pushReplacement(context, RutaPersonalizada().rutaPersonalizada(HomePage()));
                      
                      
                      },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    ),
                height: 50,
                color: Colors.transparent,
                elevation: 0,
                focusElevation: 0,
                hoverElevation: 0,
                highlightElevation: 0,
                disabledElevation: 0,
                disabledColor: Colors.grey.shade200,
                padding: const EdgeInsets.all(0),
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  decoration: BoxDecoration(
                      gradient: placeService.isLoading 
                      ? const LinearGradient(colors: [Colors.grey, Colors.grey]) 
                      : MyStyles().gradientRedToOrange,
                      borderRadius:  const BorderRadius.all(Radius.circular(10))),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 10),
                  child:  Text(placeService.isLoading ? 'Cargando': 'Crear Iglu' , 
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20
                ),
              )
            )
          )
        )
      );
  }
}

// ignore: must_be_immutable
class _HeaderProfile extends StatelessWidget {

  String urlPhoto =
      "https://www.elivapress.com/public/authors/b22c171bd7c77f05532eff05b4bacde2.png";

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      height: 90,
      padding: const EdgeInsets.only(top: 0, bottom: 10),
      child: CustomPaint(
        painter: CustomRegistro(),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: IconButton(
                onPressed: () {
                  Navigator.pushReplacement(context, RutaPersonalizada().rutaPersonalizada(HomePage()));
                },
                icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 28,
                    color: Colors.white)),
          ),
        ),
      ),
    );
  }
}

class _TitlePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return   Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  FadeInDown(
                    from: 5,
                    child: const Text('Crear', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
                  
                  Row(
                    children: [
                      FadeInLeft(
                        from: 5,
                        child: const Text('Nuevo ', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
                      FadeInRight(
                         from: 5,
                         child: const Text('Iglu', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
                    ],
                  ),
                ],
              )
          );

  }
}

class _NameIglu extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

  final formProvider = Provider.of<FormIgluProvider>(context);

    return Column(
      children: [
      
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Row(
                children:  [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: MyStyles().gradientRedToOrange
                    ),
                    child: const Icon(Icons.text_fields, color: Colors.white),
                  ),
                  const Text('Nombre del Iglu'),
                ],
              )),

            TextFormField(

              cursorColor: MyStyles().colorNaranja,
              decoration: InputDecorationIglu.decorationInput(
                context: context, 
                hinText: 'Ingrese el nombre del lugar', 
                labelTex: 'Ingrese el nombre del iglu',
                ),
                onChanged: (value) {
                  formProvider.updateName(value);
                },
                validator: (value) {
                  return (value != null && value.length >= 5)
                    ? null 
                    : 'Ingrese un nombre mayor a 5 caracteres';
                },
            ),
      ],
    );
  }
}

class _TipoLugar extends StatefulWidget {

  @override
  State<_TipoLugar> createState() => _TipoLugarState();
}

class _TipoLugarState extends State<_TipoLugar> {
  var items = [
  'Bar',
  'Barberia',
  'Biblioteca',
  'Centro comercial',
  'Colegio',
  'Comida rapida',
  'Compañía',
  'Discoteca',
  'Feria',
  'Iglesia',
  'Isla',
  'Lugar',
  'Monumento',
  'Parque',
  'Parque Acuatico',
  'Parque de diversiones',
  'Playa',
  'Plazoleta',
  'Restaurante',
  'Restaurante - Bar',
  'Spa',
  'Tienda',
  'Universidad',
  'Zoologico',
];

String valoriniciarl = 'Lugar';

 Iterable<DropdownMenuItem<String>> listamap() {
   var listaMap =  items.map((String items) {
                  return DropdownMenuItem(
                    alignment: Alignment.center,
                    value: items,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      alignment: items.length == 1 ? Alignment.center : null,
                      width: 200,
                      color: items.length == 1 ? Colors.red : Colors.transparent,
                      child: Row(
                        children: [
                      ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (rect) {
                          return MyStyles().gradientHorizontal.createShader(rect);
                        },
                        child: Icon(Icons.place_outlined, color: MyStyles().colorRojo)),
                      const SizedBox(width: 5),
                      Text(items, style: TextStyle(color: items.length == 1 ? Colors.white : Colors.black),),
                        ],
                      )),
                  );
                });

      return listaMap;
}

  @override
  Widget build(BuildContext context) {

    
  final formProvider = Provider.of<FormIgluProvider>(context);
  final placeService = Provider.of<PlaceService>(context);

    return Column(
      children: [
        Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Row(
                children:  [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: MyStyles().gradientRedToOrange
                    ),
                    child: const Icon(Icons.list_rounded, color: Colors.white),
                  ),
                  const Text('Tipo de lugar'),
                ],
              )
              ),

              DropdownButton(
                    style: const TextStyle(fontFamily: 'Roboto2', color: Colors.black),
                    // alignment: Alignment.center,
                    underline: Container(
                      decoration: BoxDecoration(
                        gradient: MyStyles().gradientRedToOrange,
                        color: MyStyles().colorRojo,
                        borderRadius:const BorderRadius.all(Radius.circular(20)
                        )
                      ),
                      alignment: Alignment.center,
                      height: 1,
                    ),
                    value:  valoriniciarl,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: listamap().toList(),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    onChanged: (value) {
                      setState(() {
                        valoriniciarl = value.toString();
                        placeService.newPlace.type = value.toString();
                        formProvider.updateType(value.toString());
                      });
                    },
                  ),
      ],
    );
  }
}

class _Location extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

  final formProvider = Provider.of<FormIgluProvider>(context);

    return Column(
      children: [
      
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Row(
                children:  [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: MyStyles().gradientRedToOrange
                    ),
                    child: const Icon(Icons.text_fields, color: Colors.white),
                  ),
                  const Text('Posición del Iglu'),
                ],
              )),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(formProvider.place.location, style: TextStyle(color: Colors.grey.shade400, fontSize: 20),),
            ),

            const Text('No puedes editar este dato', style: TextStyle(color: Colors.green, fontSize: 10),)
      ],
    );
  }
}
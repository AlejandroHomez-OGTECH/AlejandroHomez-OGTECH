import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:icebreaking_app/src/models/logins_model.dart';
import 'package:icebreaking_app/src/models/models.dart';
import 'package:icebreaking_app/src/providers/formuser_provider.dart';
import 'package:icebreaking_app/src/providers/providers.dart';
import 'package:icebreaking_app/src/services/newprofile_service.dart';
import 'package:icebreaking_app/src/styles/styles.dart';
import 'package:icebreaking_app/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

class FormPage1 extends StatelessWidget {
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
        decoration:const  BoxDecoration(
        color: Colors.white,
          borderRadius:  BorderRadius.all(Radius.circular(14)),
        ),
        child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                  _Titulo(),
                  _NombreApellido(),
                  _Genero(),
                  // _QueBusco(),
              
              ],
            )),
      ),
    );
  }
}

class _Titulo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      width: double.infinity,
      height: 155,
      child: Image.asset('assets/llamas.png', height: double.infinity),
    );
  }
}

class _NombreApellido extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    final formProvider = Provider.of<FormProfileProvider>(context, listen: false);
    final loginForm = Provider.of<FormLoginProvider>(context);

    final authClass = Provider.of<AuthClass>(context);



    return Container(
      padding:const EdgeInsets.all(10),
      child: Column(
        children: [
          Text('Nombre en pantalla', style: MyStyles().titleNewProfileStyle),
        
          TextFormField(
            initialValue: authClass.nombreUsuario.isEmpty ? loginForm.name : authClass.nombreUsuario,
            style: const TextStyle(color: Colors.black), textAlign: TextAlign.center,
            cursorColor: MyStyles().colorAzul,
            autocorrect: false,
            keyboardType: TextInputType.name,
            decoration: InputDecorationsProfile.decorationInput(
                context: context,
                hinText: 'Aqui tu nombre',
                labelTex: 'Nombre completo',
                iconData: Icons.alternate_email),
            onChanged: (value) => formProvider.updateName(value),
            validator: (value) {

               return (value != null && value.length >= 5) 
               ? null
               : 'Ingrese un valor con mas de 5 caracteres';
                  
            },
          ),
        ],
      ),
    );
  }
}

class _Genero extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Text('Genero', style: MyStyles().titleNewProfileStyle),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
                _ItemGenero(index: 0, texto: 'Hombre'),
                _ItemGenero(index: 1, texto: 'Mujer'),
                _ItemGenero(index: 2, texto: 'No binario'),
            ],
          ),
        )
      ],
    );
  }
}

class _ItemGenero extends StatelessWidget {

  final int index;
  final String texto;
  
  _ItemGenero({required this.index, required this.texto});

  @override
  Widget build(BuildContext context) {

    
    final newProfileService = Provider.of<NewProfileServices>(context);
    final formProvider = Provider.of<FormProfileProvider>(context, listen: false);


    if (newProfileService.genero == index ) {

       return FadeInDown(
         from: 5,
         child: AnimatedContainer(
          margin: const EdgeInsets.symmetric(vertical: 5),
          height: 50,
           duration: const Duration(milliseconds: 100),
           alignment: Alignment.center,
           decoration: BoxDecoration(
               borderRadius: const BorderRadius.all(Radius.circular(20)),
               border: Border.all(
                   color: newProfileService.genero == index
                       ? Colors.transparent
                       : Colors.black),
               gradient: LinearGradient(colors: [
                  MyStyles().colorAzul,
                  MyStyles().colorRojo,
               ])),
           child: Text(texto,
               style: const TextStyle(
                   color:Colors.white
                       )),
         ),
       );
      
    }

    return GestureDetector(
      onTap: () {
        newProfileService.setGenero = index;
        formProvider.updateGenero(index);
      },
      child: AnimatedContainer(
        margin: const EdgeInsets.symmetric(vertical: 5),
        height: 50,
        duration: const Duration(milliseconds: 100),
        alignment: Alignment.center,
          decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(color: newProfileService.genero == index ? Colors.transparent : Colors.black , width: 0.5),
          gradient: LinearGradient(colors: [
            newProfileService.genero == index ? MyStyles().colorAzul : Colors.white,
            newProfileService.genero == index ? MyStyles().colorRojo : Colors.white,
          ])
        ),
        child: Text(texto, style: TextStyle(color: newProfileService.genero == index ? Colors.white : Colors.black)),
      ),
    );
  }
}

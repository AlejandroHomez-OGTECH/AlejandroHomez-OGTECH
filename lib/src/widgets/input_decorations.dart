import 'package:flutter/material.dart';
import 'package:icebreaking_app/src/styles/styles.dart';


//Decoracion del login

class  InputDecorations {
  static InputDecoration decorationInput({
    required BuildContext context,
    required String hinText,
    required String labelTex,
    IconData? iconData
  }) {

    return InputDecoration(
                errorStyle: const TextStyle(color: Colors.white),
                contentPadding: const EdgeInsets.all(10),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(width: 2, color: Colors.white)),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.white)
                ),
                enabledBorder:  const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.white54)
                ),
                hintText: hinText,
                hintStyle:const TextStyle(color: Colors.white54),
                labelText: labelTex,
                labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
                prefixIcon: iconData != null 
                ? Icon(iconData, color:  Colors.white)
                : null
              );

  }
}


//Decoracion del perfil

class  InputDecorationsProfile {
  static InputDecoration decorationInput({
    required BuildContext context,
    required String hinText,
    required String labelTex,
    IconData? iconData
  }) {

    return InputDecoration(
                errorStyle: TextStyle(color: MyStyles().colorRojo),
                contentPadding: const EdgeInsets.all(15),

                border: const UnderlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(width: 2, color: Colors.black)),

                focusedBorder: UnderlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: MyStyles().colorAzul)
                ),

                enabledBorder:  const UnderlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.grey)
                ),
                hintText: hinText,
                hintStyle:const TextStyle(color: Colors.grey),
                labelText: null,
                labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
                prefixIcon: iconData != null 
                ? Icon(iconData, color:  Colors.white)
                : null
              );

  }

}


//EditarPerfil


class InputDecorationEditar {

  static InputDecoration decorationInput({
      required BuildContext context,
      required String hinText,
      required String labelTex,
      IconData? iconData
      
      }) {
    return InputDecoration(
        errorStyle: TextStyle(color: MyStyles().colorRojo),
        contentPadding: const EdgeInsets.all(15),

        border: const UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(width: 2, color: Colors.black)),

        focusedBorder: const UnderlineInputBorder(
            borderRadius:  BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Colors.transparent)),


        enabledBorder: const UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Colors.transparent)),


        hintText: hinText,
        hintStyle: const TextStyle(color: Colors.grey),
        labelText: null,
        labelStyle:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
        prefixIcon:
            iconData != null ? Icon(iconData, color: MyStyles().colorRojo) : null);
  }
}

//Crear Iglu


class InputDecorationIglu {

  static InputDecoration decorationInput({
      required BuildContext context,
      required String hinText,
      required String labelTex,
      IconData? iconData
      
      }) {
    return InputDecoration(
        errorStyle: TextStyle(color: MyStyles().colorRojo),
        contentPadding: const EdgeInsets.all(15),

        border: const UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(width: 2, color: Colors.black)),

        focusedBorder:  UnderlineInputBorder(
            borderRadius:  const BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: MyStyles().colorRojo)),


        enabledBorder: const UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Colors.transparent)),


        hintText: hinText,
        hintStyle:  TextStyle(color: Colors.grey.shade400),
        labelText: null,
        labelStyle:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
        prefixIcon:
            iconData != null ? Icon(iconData, color: MyStyles().colorRojo) : null);
  }
}

//Chat

class InputDecorationChat {

  static InputDecoration decorationInput({
      required BuildContext context,
      required String hinText,
      IconData? iconData
      
      }) {
    return InputDecoration(
        errorStyle: TextStyle(color: MyStyles().colorRojo),
        contentPadding: const EdgeInsets.only(bottom: 10, left: 8, right: 8),

        border: const UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(width: 2, color: Colors.black)),

        focusedBorder:  const UnderlineInputBorder(
            borderRadius:  BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Colors.transparent)),


        enabledBorder: const UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Colors.transparent)),


        hintText: hinText,
        hintStyle:  TextStyle(color: Colors.grey.shade400, fontSize: 13),
        labelText: null,
        labelStyle:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
        );
  }
}
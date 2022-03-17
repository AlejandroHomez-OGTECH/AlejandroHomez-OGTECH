
import 'package:flutter/material.dart';
import 'package:icebreaking_app/src/styles/styles.dart';

class NotificationsService {

  static GlobalKey<ScaffoldMessengerState> messagerKey =  GlobalKey<ScaffoldMessengerState>();


  static showSnackBar(String message) {

    final scakBar =  SnackBar(

      elevation: 0,
      duration:const Duration(seconds: 4),
      backgroundColor:  MyStyles().colorRojo,
      content: Text(message , style:const  TextStyle(color: Colors.white, fontSize: 15),));

  messagerKey.currentState!.showSnackBar(scakBar);

  }



}
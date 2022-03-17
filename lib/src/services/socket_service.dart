// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icebreaking_app/src/global/environment.dart';
import 'package:icebreaking_app/src/models/models.dart';
import 'package:icebreaking_app/src/services/auth_service.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting
}


class SocketService with ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  
  IO.Socket get socket => _socket;
  Function get emit => _socket.emit;

 


  void connect() async {

    final token = await AuthService.getToken();
    // Dart client
    _socket = IO.io(Environment.socketUrl , {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew' : true,
      'extraHeaders' : {
      'x-token' : token
      }
    });

    _socket.on('connect', (_) async {
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    _socket.on('disconnect', (_) async  {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
  }

  void disconnect() async {
    _socket.disconnect();
  }


  Future<String> updateUserIce(UserIce user, bool value) async {

    await FirebaseFirestore.instance
        .collection('icebreaking_users')
        .doc(user.id)
        .update({'online': value})
        .catchError((error) => print("Error al actualizar usuario user: $error"));
    notifyListeners();
    return user.fullName;
  }

}
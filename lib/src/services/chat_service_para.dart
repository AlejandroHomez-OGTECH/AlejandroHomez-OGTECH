import 'package:flutter/material.dart';
import 'package:icebreaking_app/src/global/environment.dart';
import 'package:icebreaking_app/src/models/mensajes_response.dart';
import 'package:icebreaking_app/src/models/usuario.dart';
import 'package:http/http.dart' as http;
import 'package:icebreaking_app/src/services/auth_service.dart';

class ChatServicePara with ChangeNotifier {

  late Usuario usuarioPara;


  Future<List<Mensaje>> getChat( String usuarioID) async {

    final token =  await AuthService.getToken();

      final uri  = Uri.parse('${Environment.apiUrl}/mensajes/$usuarioID');
      final resp = await http.get(uri ,
      headers: {
        'Content-Type' : 'application/json' ,
        'x-token' : token!
      });

      final mensajesResponse = mensajesResponseFromJson(resp.body);

      return mensajesResponse.mensajes;


  }


}
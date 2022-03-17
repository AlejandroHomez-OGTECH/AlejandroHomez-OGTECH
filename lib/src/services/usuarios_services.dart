import 'package:icebreaking_app/src/global/environment.dart';
import 'package:icebreaking_app/src/models/usuario.dart';
import 'package:http/http.dart' as http;
import 'package:icebreaking_app/src/models/usuarios_response.dart';
import 'package:icebreaking_app/src/services/services.dart';

class UsuariosService {

  Future<List<Usuario>> getUsuarios() async {

   final token  =  await AuthService.getToken();   

    try {
      final uri = Uri.parse('${ Environment.apiUrl }/usuarios');
      final resp = await http.get( uri ,
      headers: {
        'Content-Type' : 'application/json',
         'x-token' : token!
         }
      );

      final usuariosResponse  = usuariosResponseFromJson( resp.body );

      return usuariosResponse.usuarios;

    } catch (e) {
      return [];
    }
  }
}
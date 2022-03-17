import 'dart:io';

class Environment {
// static String apiUrl = Platform.isAndroid
//   ? 'http://192.168.1.11:3000/api'
//   : 'http://localhost:3000/api';

  static String apiUrl = Platform.isAndroid
      ? 'https://icebreaking-server.herokuapp.com/api'
      : 'https://icebreaking-server.herokuapp.com/api';

  static String socketUrl = Platform.isAndroid
      ? 'https://icebreaking-server.herokuapp.com/'
      : 'https://icebreaking-server.herokuapp.com/';
}

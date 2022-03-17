import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icebreaking_app/src/models/mensajes_response.dart';
import 'package:icebreaking_app/src/models/models.dart';
import 'package:icebreaking_app/src/models/usuario.dart';
import 'package:icebreaking_app/src/pages/home/navigation/chat/list_chats_page.dart';
import 'package:icebreaking_app/src/services/services.dart';
import 'package:icebreaking_app/src/styles/styles.dart';
import 'package:icebreaking_app/src/widgets/CustomsPainters/customregistro.dart';
import 'package:icebreaking_app/src/widgets/chat/chat_message.dart';
import 'package:icebreaking_app/src/widgets/input_decorations.dart';
import 'package:icebreaking_app/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ChatSelected extends StatefulWidget {
  @override
  State<ChatSelected> createState() => _ChatSelectedState();
}

class _ChatSelectedState extends State<ChatSelected> with TickerProviderStateMixin {

  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  late ChatServicePara chatServicePara;
  late ChatServices chatServices;
  late SocketService socketService;
  late AuthService authService;
  
  List<ChatMessage> _messages = [];
 

  bool _estaEscribiendo = false;

  @override
  void initState() {
    super.initState();

    chatServicePara = Provider.of<ChatServicePara>(context, listen: false);
    chatServices = Provider.of<ChatServices>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    chatServices.messages = [];

    socketService.socket.on('mensaje-personal', _escucharMensaje);
    
    _cargarHistorial(chatServicePara.usuarioPara.uid);

  }

  void _escucharMensaje(dynamic payload) {
    ChatMessage message = ChatMessage(
        texto: payload['mensaje'], 
        uId: payload['de']);
    chatServices.createMessage(payload['de'], payload['mensaje']);

     setState(() {
      _messages.insert(0, message);
    });
  }

  void _cargarHistorial(String usuarioID) async {

    List<Mensaje> chat = await chatServicePara.getChat(usuarioID);
    
    final history = chat.map((m) => ChatMessage(texto: m.mensaje, uId: m.de));

   setState(() {
      _messages.insertAll(0, history);
    });
  }

  @override
  void dispose() {
    socketService.socket.off('mensaje-personal');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatServices = Provider.of<ChatServices>(context);

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.11),
              child: Column(
                children: [
                  _messages.isEmpty
                      ? Expanded(child: Container())
                      : Flexible(
                          child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: _messages.length,
                          itemBuilder: (context, i) => _messages[i],
                          reverse: true,
                        )),
                  Container(
                    margin: const EdgeInsets.only(top: 5, bottom: 5),
                    width: double.infinity,
                    height: 1,
                    decoration:
                        BoxDecoration(gradient: MyStyles().gradientHorizontal),
                  ),

                  SafeArea(
                    top: false,
                    left: false,
                    right: false,
                    bottom: true,
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(right: 5, left: 0, bottom: 10),
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(FontAwesomeIcons.microphoneAlt)),
                          Flexible(
                              child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: const BorderRadius.all(Radius.circular(20))),
                            child: TextField(
                              cursorColor: MyStyles().colorNaranja,
                              style: const TextStyle(color: Colors.black87, fontSize: 14),
                              controller: _textController,
                              focusNode: _focusNode,
                              onSubmitted: _handleSubmit,
                              onChanged: (texto) {
                                setState(() {
                                  if (texto.trim().isNotEmpty) {
                                    _estaEscribiendo = true;
                                  } else {
                                    _estaEscribiendo = false;
                                  }
                                });
                              },
                              decoration: InputDecorationChat.decorationInput(
                                context: context,
                                hinText: 'Escribe',
                              ),
                            ),
                          )),
                          IconButton(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onPressed: () {},
                              icon: Image.asset('assets/llamas.png', fit: BoxFit.cover)),
                          GestureDetector(
                            onTap: _estaEscribiendo
                                ? () => _handleSubmit(_textController.text.trim())
                                : null,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.all(10),
                              width: 80,
                              decoration: BoxDecoration(
                                  gradient: _estaEscribiendo
                                      ? MyStyles().gradientHorizontal
                                      : LinearGradient(
                                          colors: [Colors.grey.shade300, Colors.grey]),
                                  borderRadius: const BorderRadius.all(Radius.circular(50))),
                              child: const Center(
                                  child:
                                      Text('Enviar', style: TextStyle(color: Colors.white))),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            _HeaderProfile(),
          ],
        ),
      ),
    );
  }
  _handleSubmit(String texto) async {

    if ( texto.isEmpty ) return;

    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);
    final chatServicePara = Provider.of<ChatServicePara>(context, listen: false);

    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      texto: texto, 
      uId: authService.usuario!.uid);

    _messages.insert(0, newMessage);

    setState(() { _estaEscribiendo = false; });

    socketService.emit('mensaje-personal', {
      'de': authService.usuario!.uid,
      'para': chatServicePara.usuarioPara.uid,
      'mensaje': texto
    });
  }
}

class _HeaderProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final chatServices = Provider.of<ChatServices>(context);
    final chatServicesPara = Provider.of<ChatServicePara>(context);

    UserIce user = chatServices.userChatSelected;
    Usuario userPara = chatServicesPara.usuarioPara;

    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.15,
      padding: const EdgeInsets.only(top: 0, bottom: 10),
      child: CustomPaint(
        painter: CustomRegistro(),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () => Navigator.push(context, RutaPersonalizada().rutaPersonalizada(ListChatsPage())),
                      icon: const Icon(Icons.arrow_back_ios_new_outlined),
                      color: Colors.white),
                  const Spacer(),
                  CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 5,
                      child: Icon(Icons.circle,
                          color: userPara.online
                              ? Colors.greenAccent[400]
                              : MyStyles().colorRojo,
                          size: 10)),
                  const SizedBox(width: 5),
                  SizedBox(
                      width: 235,
                      child: Text(
                        user.fullName,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
                  const Spacer(),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.settings),
                      color: Colors.white),
                ],
              )),
        ),
      ),
    );
  }
}

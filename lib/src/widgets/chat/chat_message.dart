import 'package:flutter/material.dart';
import 'package:icebreaking_app/src/models/models.dart';
import 'package:icebreaking_app/src/services/auth_service.dart';
import 'package:icebreaking_app/src/services/chat_service.dart';
import 'package:icebreaking_app/src/services/profile_service.dart';
import 'package:icebreaking_app/src/styles/styles.dart';
import 'package:provider/provider.dart';

class ChatMessage extends StatelessWidget {

  final String texto;
  final String uId;

  const ChatMessage({Key? key, 
          required this.texto, 
          required this.uId, 
        }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    final authServices = Provider.of<AuthService>(context);

    return uId == authServices.usuario!.uid
    ? MyMessage(texto: texto,)
    : NoMyMessage(texto: texto,);

  }
}


class MyMessage extends StatefulWidget {

  final String texto;

  const MyMessage({Key? key, required this.texto}) : super(key: key);

  @override
  State<MyMessage> createState() => _MyMessageState();
}

class _MyMessageState extends State<MyMessage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {

    final profileServices = Provider.of<ProfileServices>(context);
    final size = MediaQuery.of(context).size;

    UserIce myUser = profileServices.newUser;


    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [

            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: size.width * 0.85, minWidth: size.width * 0.0),
              child: Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(
                    bottom: 5,
                    right: 5,
                    left: 50
                  ),
                  child: Text(widget.texto,  style: const TextStyle(color: Colors.white)),
                  decoration: BoxDecoration(
                    color: MyStyles().colorRojo,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(0),
                      bottomLeft: Radius.circular(8),
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    )
                  ),
              ),
            ),

            
            myUser.profilePhoto.isEmpty
                  ? CircleAvatar(
                     backgroundColor: Colors.grey.shade300,
                      radius: 13,
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Image.asset('assets/llamas_4.png'),
                      ),
                    )
                  : CircleAvatar(
                      radius: 13,
                      backgroundImage: NetworkImage(myUser.profilePhoto),
                    ),
          ],
        ),
      ));
  }
}


class NoMyMessage extends StatelessWidget {

  final String texto;
  const NoMyMessage({Key? key, required this.texto}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final chatServices = Provider.of<ChatServices>(context);
    final size = MediaQuery.of(context).size;

    UserIce noMyUser = chatServices.userChatSelected;

    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            noMyUser.profilePhoto.isEmpty

            ? CircleAvatar(
              backgroundColor: Colors.grey.shade200,
              radius: 13,
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Image.asset('assets/llamas_4.png'),
              ),
            )
            : CircleAvatar(
              radius: 13,
              backgroundImage: NetworkImage(noMyUser.profilePhoto),
            ),
            
            
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: size.width * 0.85, minWidth: size.width * 0.0),
              child: Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(
                    bottom: 5,
                    left: 5,
                    right: 30
                  ),
                  child: Text(texto,  style: const TextStyle(color: Colors.black87)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(8),
                      bottomLeft: Radius.circular(0),
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    )
                  ),
              ),
            ),
          ],
        ),
      ));
  }
}
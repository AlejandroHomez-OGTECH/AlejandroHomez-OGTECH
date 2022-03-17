
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icebreaking_app/src/models/models.dart';
import 'package:icebreaking_app/src/widgets/chat/chat_message.dart';

class ChatServices extends ChangeNotifier {
  
  FirebaseAuth auth = FirebaseAuth.instance;

  List<UserIce> listChat = [];
  bool _existUsers = false;
  List<ChatMessage> messages = []; 

  late UserIce userChatSelected;

  bool get existUsers => _existUsers;
  set setExistUsers (bool value) {
    _existUsers = value;
    notifyListeners();
  }

  //length

  int _lengthUsersChat = 0;

  int get lengthUsersChat => _lengthUsersChat;
  set setLengthUsersChat(int value) {
    _lengthUsersChat = value;
    notifyListeners();
  }

  //


  List<ChatMessage> createMessage(String uId, String texto) {

    final newMessage =  ChatMessage(texto: texto, uId: uId);
     messages.insert(0, newMessage);

    notifyListeners();
    return messages;
  }

  Future<List<UserIce>> loadUserChat(List<String> listUsersId) async {

  if(lengthUsersChat == listUsersId.length) return listChat;
  
  if (listUsersId.isNotEmpty){

      await FirebaseFirestore.instance
            .collection('icebreaking_users')
            .orderBy('id')
            .get()
            .then(( QuerySnapshot value){

            int _contador1 = 0;
            listChat.clear();

            while (_contador1 < value.docs.length)  {

                for (int i = 0; i < listUsersId.length; i++) {

                    String id = value.docs[_contador1].id;

                    if ( listUsersId[i] == id ) {

                        UserIce user = UserIce(
                          id: value.docs[_contador1].id,
                          fullName: value.docs[_contador1]["fullName"],
                          selfiePhoto: value.docs[_contador1]["selfiePhoto"],
                          email: value.docs[_contador1]["email"],
                          phoneNumber: value.docs[_contador1]["phoneNumber"],
                          profilePhoto: value.docs[_contador1]["profilePhoto"],
                          dateOfBirth: value.docs[_contador1]["dateOfBirth"],
                          gender: value.docs[_contador1]["gender"],
                          interest: value.docs[_contador1]["interest"],
                          youSearch: value.docs[_contador1]["youSearch"],
                          howAmI: value.docs[_contador1]["howAmI"],
                          profession: value.docs[_contador1]["profession"],
                          ancestry: value.docs[_contador1]["ancestry"],
                          languages:
                              List<String>.from(value.docs[_contador1]["languages"].map((x) => x)),
                          myPictures: List<String>.from(
                              value.docs[_contador1]["myPictures"].map((x) => x)),
                          biography: value.docs[_contador1]["biography"],
                          socialNetworks: List<String>.from(
                              value.docs[_contador1]["socialNetworks"].map((x) => x)),
                          likes: value.docs[_contador1]["likes"],
                          edadRangeDesde: value.docs[_contador1]["edadRangeDesde"],
                          edadRangeHasta: value.docs[_contador1]["edadRangeHasta"],
                          likesMe: List<String>.from(value.docs[_contador1]["likesMe"].map((x) => x)),
                          myLikes: List<String>.from(value.docs[_contador1]["myLikes"].map((x) => x)),
                          iceMe: List<String>.from(value.docs[_contador1]["iceMe"].map((x) => x)),
                          match: List<String>.from(value.docs[_contador1]["match"].map((x) => x)),
                          myIces: List<String>.from(value.docs[_contador1]["myIces"].map((x) => x)),
                          online: value.docs[_contador1]["online"],

                        );

                        listChat.add(user);
                        break;
                        
                      }
                  }  
                    _contador1++;
                }        
              }
            );

            setLengthUsersChat = listUsersId.length;

          } 
    return listChat;   
    }

}
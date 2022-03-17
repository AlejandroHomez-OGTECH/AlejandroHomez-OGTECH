import 'dart:io';

import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:icebreaking_app/src/models/models.dart';
import 'package:icebreaking_app/src/preferencias/preferencias_usuario.dart';
import 'package:icebreaking_app/src/providers/providers.dart';
import 'package:image_picker/image_picker.dart';

class ProfileServices extends ChangeNotifier {

  final String cloudinaryCustomFolder = "test/profilephotos";
  final String cloudinaryApiKey = "283326886228813";
  final String cloudinaryApiSecret = "Q7BjzzWPGiKT9j1832PnuuABAFc";
  final String cloudinaryCloudName = "og-tech-sas";

  bool loading = false;

  final PageController _pageController = PageController();
  FirebaseAuth auth = FirebaseAuth.instance;

  FormLoginProvider form = FormLoginProvider();
  final pref = PreferenciasUsurario();


  int _paginaActual = 0;
  double _itemSeleccionado = 0.0;
  bool _loadUpdateIce = false;
  bool _existeusuario = false;
  bool _loadSelfie = false;
  bool _likeThisUser = true;
  bool _iceThisUser = true;
  bool _primeraEntrada = false;
  bool _match = false;
  int _likeCountProfile = 0;

  List<UserIce> listUsersFromList = [];


  File? newImage;
  File? selfiePhoto;
  List<String> listaPaths = [];
  List<String> listaPathsAnteriores = [];
  late List<File> newImages;
  late String urlphoto;
  List<String> urlphotos = [];
  bool isSaving = false;

  List<UserIce> usersForIglu  = [];

  late UserIce newUser;
  late UserIce tempUser;

  //Length

  bool _hayUsuario = false;
  int _lengthUsersForPlace = 0;


  bool get hayUsuario => _hayUsuario;
  set setHayUsuario(bool value) {
    _hayUsuario = value;
    notifyListeners();
  }

  int get lengthUsersForPlace => _lengthUsersForPlace;
  set setLengthUsersForPlace(int value) {
    _lengthUsersForPlace = value;
    notifyListeners();
  }

  //

  bool get primeraEntrada => _primeraEntrada;
  set setPrimeraEntrada(bool value) {
    _primeraEntrada = value;
    notifyListeners();
  }


  bool get boolMatch => _match;
  set setBoolMatch(bool value) {
    _match = value;
    notifyListeners();
  }

  bool get likeThisUser => _likeThisUser;
  set setLikeThisUser(bool value) {
    _likeThisUser = value;
    notifyListeners();
  }

    bool get iceThisUser => _iceThisUser;
  set setIceThisUser(bool value) {
    _iceThisUser = value;
    notifyListeners();
  }

  bool get existeUsuario => _existeusuario;
  set setExisteusuario(bool value) {
    _existeusuario = value;
    notifyListeners();
  }

  bool get loadUpdateIce => _loadUpdateIce;
  set setLoadUpdateIce(bool value) {
    _loadUpdateIce = value;
    notifyListeners();
  }

   bool get loadSelfie => _loadSelfie;
  set setLoadSelfie(bool value) {
    _loadSelfie = value;
    notifyListeners();
  }

  int get likeProfile => _likeCountProfile;
  set setLikeProfile(int value) {
    _likeCountProfile = value;
    notifyListeners();
  }

  PageController get pageController => _pageController;
  double get itemSeleccionado => _itemSeleccionado;
  int get paginaActual => _paginaActual;

  set setItemSeleccionado(double value) {
    _itemSeleccionado = value;
    notifyListeners();
  }

  set paginaActual(int valor) {
    _paginaActual = valor;
    _pageController.animateToPage(valor,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCirc);

    notifyListeners();
  }

//Validaciones
Future<void> validarLike() async {

        UserIce userSendMyLikes = newUser;
        UserIce userSendLike = tempUser;
        setLikeThisUser = false;

        if (userSendMyLikes.myLikes!.isNotEmpty) {

            for (var i = 0; i < userSendMyLikes.myLikes!.length; i++) {
              
                if (userSendLike.id ==  userSendMyLikes.myLikes![i]) {
                  setLikeThisUser = true;
                } 
              }
            }

  }

Future<void> validarIce() async {

        UserIce userSendMyLikes = newUser;
        UserIce userSendLike = tempUser;
        
        setIceThisUser = false;

        if (userSendMyLikes.myIces!.isNotEmpty) {

            for (var i = 0; i < userSendMyLikes.myIces!.length; i++) {
              
                if (userSendLike.id ==  userSendMyLikes.myIces![i]) {
                  setIceThisUser = true;
                } 
              }
            }

  }


//Wingk y Ice
Future<void> like(bool isLiked) async{
  
        UserIce userSendLike = tempUser;
        UserIce userSendMyLikes = newUser;

      if (likeThisUser) {

          switch (isLiked) {
          case false : {

                userSendLike.likes = likeProfile;
                userSendLike.likesMe!.add(newUser.id!);
                await updateUserIce(userSendLike);
                tempUser = userSendLike;


                //Agregar a nuestro
                userSendMyLikes.myLikes!.add(userSendLike.id!);
                await updateUserIce(userSendMyLikes);
                newUser = userSendMyLikes;


                break;

          }
          case true : {

                userSendMyLikes.myLikes!.remove(userSendLike.id!);
                await updateUserIce(userSendMyLikes);
                newUser = userSendMyLikes;


                userSendLike.likes = likeProfile - 1;
                setLikeProfile = userSendLike.likes;
                userSendLike.likesMe!.remove(newUser.id!);
                await updateUserIce(userSendLike);
                tempUser = userSendLike;

              break;
          }
            
        }       
      } else {
            switch (isLiked) {
                    case false:
                      {
                        userSendLike.likes = likeProfile + 1;
                        setLikeProfile = userSendLike.likes;
                        userSendLike.likesMe!.add(newUser.id!);
                        await updateUserIce(userSendLike);
                        tempUser = userSendLike;


                        //Agregar a nuestro
                        userSendMyLikes.myLikes!.add(userSendLike.id!);
                        await updateUserIce(userSendMyLikes);
                       newUser = userSendMyLikes;


                        

                        break;
                      }
                    case true:
                      {
                        userSendMyLikes.myLikes!.remove(userSendLike.id!);
                        await updateUserIce(userSendMyLikes);
                        newUser = userSendMyLikes;

                        userSendLike.likes = likeProfile;
                        userSendLike.likesMe!.remove(newUser.id!);
                        await updateUserIce(userSendLike);     
                        tempUser = userSendLike;

                        break;
                      }
               }      
      }

            FormProfileProvider(newUser).user;
            setPrimeraEntrada = false;
            
        }

Future<void> ice(bool isIce) async{
  
        UserIce userSendIce = tempUser;
        UserIce userSendMyIces = newUser;

        switch (isIce) {

          case false : {

                //Agregar mi id al perfil que estoy viendo
                userSendIce.iceMe!.add(newUser.id!);
                await updateUserIce(userSendIce);
                tempUser = userSendIce;

                //Agregar id del perfil que estoy viendo a mi perfil
                userSendMyIces.myIces!.add(userSendIce.id!);
                await updateUserIce(userSendMyIces);
                newUser = userSendMyIces;


                      
                bool booleanValue = await match(userSendMyIces, userSendIce, false);
                setBoolMatch = booleanValue;


                break;
          }
          case true : {

                //Quitar id del perfil que estoy viendo a mi perfil
                userSendMyIces.myIces!.remove(userSendIce.id!);
                await updateUserIce(userSendMyIces);
                newUser = userSendMyIces;
                
                //Quitar mi id al perfil que estoy viendo
                userSendIce.iceMe!.remove(newUser.id!);
                await updateUserIce(userSendIce);
                tempUser = userSendIce;

                
                bool booleanValue = await match(userSendMyIces, userSendIce, true);
                setBoolMatch = booleanValue;


              break;
          }
            
        }     

            FormProfileProvider(newUser).user;
          
        }


//Match o Break

Future<bool> match(UserIce myUser, UserIce userProfile, bool remove) async {

    int _contador1 = 0;
    int _contador2 = 0;
    bool _myUserMatch = false;
    bool _userProfileMatch = false;

    bool _isMath = false;

    //Validar si el Userprofile me dio Ice
  if (myUser.iceMe!.isNotEmpty) {
    
      while (_contador1 < myUser.iceMe!.length) {

          if ( userProfile.id == myUser.iceMe![_contador1] ) {
            _contador1++;
            _myUserMatch = true;
          } else {
            _contador1++;
          }
    }
  }

  //Validar si el userProfile me dio Ice
  if (userProfile.iceMe!.isNotEmpty) {
    
      while (_contador2 < userProfile.iceMe!.length) {

          if ( myUser.id == userProfile.iceMe![_contador2] ) {
            _contador2++;
            _userProfileMatch = true;
          } else {
            _contador2++;
          }
    }
  }

   if (_myUserMatch == true && _userProfileMatch == false && remove == true || 
       _myUserMatch == false && _userProfileMatch == true && remove == true ) {
      //Elimnar id de Userprofile ami perfil match
      myUser.match!.remove(userProfile.id!);
      await updateUserIce(myUser);

      //Eliminar mi id de Userprofile match
      userProfile.match!.remove(myUser.id!);
      await updateUserIce(userProfile);

      _isMath = false;
      notifyListeners();
      return _isMath;
    } 

  if (_myUserMatch == true && _userProfileMatch == true && remove == false) {

    _isMath = true;

    //Agreagar id UserProfile match
    myUser.match!.add(userProfile.id!);
     await updateUserIce(myUser);
    
    //Agreagar mi id a UserProfile match
    userProfile.match!.add(myUser.id!);
     await updateUserIce(userProfile);
    
    notifyListeners();
     return _isMath ; 

  } else {
      _isMath = false;
      notifyListeners();
      return _isMath;
  }
  
 
    

}


//Usuarios segun iglu seleccionado
Future<List<UserIce>> loadUsersForPlace(List<String> listaUsers, String myProfile) async {

  await FirebaseFirestore.instance
          .collection('icebreaking_users')
          .orderBy('fullName')
          .get()
          .then((QuerySnapshot value) {


    if ( value.docs.length == lengthUsersForPlace ) {
        return usersForIglu;
      }

    usersForIglu.clear();
    
    for (var h = 0; h < listaUsers.length; h++) {

        for (var i = 0; i < value.docs.length; i++) {

          if (listaUsers[h] == value.docs[i].id) {

            if (value.docs[i].id != myProfile) {

              UserIce user = UserIce(
                id: value.docs[i].id,
                fullName: value.docs[i]["fullName"],
                selfiePhoto: value.docs[i]["selfiePhoto"],
                email: value.docs[i]["email"],
                phoneNumber: value.docs[i]["phoneNumber"],
                profilePhoto: value.docs[i]["profilePhoto"],
                dateOfBirth: value.docs[i]["dateOfBirth"],
                gender: value.docs[i]["gender"],
                interest: value.docs[i]["interest"],
                youSearch: value.docs[i]["youSearch"],
                howAmI: value.docs[i]["howAmI"],
                profession: value.docs[i]["profession"],
                ancestry: value.docs[i]["ancestry"],
                languages:
                    List<String>.from(value.docs[i]["languages"].map((x) => x)),
                myPictures: List<String>.from(
                    value.docs[i]["myPictures"].map((x) => x)),
                biography: value.docs[i]["biography"],
                socialNetworks: List<String>.from(
                    value.docs[i]["socialNetworks"].map((x) => x)),
                likes: value.docs[i]["likes"],
                edadRangeDesde: value.docs[i]["edadRangeDesde"],
                edadRangeHasta: value.docs[i]["edadRangeHasta"],
                likesMe: List<String>.from(value.docs[i]["likesMe"].map((x) => x)),
                myLikes: List<String>.from(value.docs[i]["myLikes"].map((x) => x)),
                iceMe: List<String>.from(value.docs[i]["iceMe"].map((x) => x)),
                match: List<String>.from(value.docs[i]["match"].map((x) => x)),
                myIces: List<String>.from(value.docs[i]["myIces"].map((x) => x)),
                online: value.docs[i]["online"],
              );

              usersForIglu.add(user);
              break;
              
            }
             
            }

           }
          }
        setLengthUsersForPlace =  value.docs.length;
        }
      );
    notifyListeners();
    return usersForIglu;
  }

//Cargar un usuarios desde una lista de String recibida
Future<List<UserIce>> loadUsersFromList( List<String> listaUsers) async {
    

    await FirebaseFirestore.instance
        .collection('icebreaking_users')
        .orderBy('fullName')
        .get()
        .then((QuerySnapshot value) {
  
      listUsersFromList.clear();

      for (var h = 0; h < listaUsers.length; h++) {

        for (var i = 0; i < value.docs.length; i++) {

          if (listaUsers[h] == value.docs[i].id) {

              UserIce newUser = UserIce(
                id: value.docs[i].id,
                fullName: value.docs[i]["fullName"],
                selfiePhoto: value.docs[i]["selfiePhoto"],
                email: value.docs[i]["email"],
                phoneNumber: value.docs[i]["phoneNumber"],
                profilePhoto: value.docs[i]["profilePhoto"],
                dateOfBirth: value.docs[i]["dateOfBirth"],
                gender: value.docs[i]["gender"],
                interest: value.docs[i]["interest"],
                youSearch: value.docs[i]["youSearch"],
                howAmI: value.docs[i]["howAmI"],
                profession: value.docs[i]["profession"],
                ancestry: value.docs[i]["ancestry"],
                languages:
                    List<String>.from(value.docs[i]["languages"].map((x) => x)),
                myPictures: List<String>.from(
                    value.docs[i]["myPictures"].map((x) => x)),
                biography: value.docs[i]["biography"],
                socialNetworks: List<String>.from(
                    value.docs[i]["socialNetworks"].map((x) => x)),
                likes: value.docs[i]["likes"],
                edadRangeDesde: value.docs[i]["edadRangeDesde"],
                edadRangeHasta: value.docs[i]["edadRangeHasta"],
                likesMe:
                    List<String>.from(value.docs[i]["likesMe"].map((x) => x)),
                myLikes:
                    List<String>.from(value.docs[i]["myLikes"].map((x) => x)),
                iceMe: List<String>.from(value.docs[i]["iceMe"].map((x) => x)),
                match: List<String>.from(value.docs[i]["match"].map((x) => x)),
                myIces:
                    List<String>.from(value.docs[i]["myIces"].map((x) => x)),
                online: value.docs[i]["online"],

              );

              listUsersFromList.add(newUser);
              break;
          }
        }
      }
    });
    notifyListeners();
    return listUsersFromList;
  }



//Crear un usuario en Firebase y mongoDb
Future<String> createUserIce(UserIce user) async {

    await FirebaseFirestore.instance.collection('icebreaking_users').add({
      'id': '',
      'fullName': user.fullName,
      'gender': user.gender,
      'email': user.email,
      'youSearch': user.youSearch,
      'edadRangeDesde': user.edadRangeDesde,
      'edadRangeHasta': user.edadRangeHasta,
      'howAmI': user.howAmI,
      'profilePhoto': user.profilePhoto,
      'dateOfBirth': user.dateOfBirth,
      'interest': user.interest,
      'phoneNumber': user.phoneNumber,
      'profession': user.profession,
      'ancestry': user.ancestry,
      'languages': user.languages,
      'myPictures': user.myPictures,
      'biography': user.biography,
      'socialNetworks': user.socialNetworks,
      'likes': user.likes,
      'selfiePhoto': user.selfiePhoto,
      'myLikes': user.myLikes,
      'likesMe': user.likesMe,
      'iceMe': user.iceMe,
      'myIces': user.myIces,
      'match': user.match,
      'online': user.online
      
    });

    UserIce userLoad = await loadUsersIce();
    
    updateUserIce(userLoad);

    newUser = user;
    return user.fullName;
  }


//Actualizar y cargar usuarios

Future<String> updateUserIce(UserIce user) async {
    await FirebaseFirestore.instance
        .collection('icebreaking_users')
        .doc(user.id)
        .set({
      'id': user.id,
      'fullName': user.fullName,
      'gender': user.gender,
      'email': user.email,
      'youSearch': user.youSearch,
      'edadRangeDesde': user.edadRangeDesde,
      'edadRangeHasta': user.edadRangeHasta,
      'howAmI': user.howAmI,
      'profilePhoto': user.profilePhoto,
      'dateOfBirth': user.dateOfBirth,
      'interest': user.interest,
      'phoneNumber': user.phoneNumber,
      'profession': user.profession,
      'ancestry': user.ancestry,
      'languages': user.languages,
      'myPictures': user.myPictures,
      'biography': user.biography,
      'socialNetworks': user.socialNetworks,
      'likes': user.likes,
      'selfiePhoto': user.selfiePhoto,
      'myLikes': user.myLikes,
      'likesMe': user.likesMe,
      'iceMe': user.iceMe,
      'myIces': user.myIces,
      'match': user.match,
      'online' : user.online
    });
    return user.fullName;
  }

 Future<UserIce> loadUsersIce() async {

    await FirebaseFirestore.instance
        .collection('icebreaking_users')
        .orderBy('id')
        .get()
        .then((QuerySnapshot value) {

        UserIce user = UserIce(
          id: value.docs[0].id,
          fullName: value.docs[0]["fullName"],
          selfiePhoto: value.docs[0]["selfiePhoto"],
          email: value.docs[0]["email"],
          phoneNumber: value.docs[0]["phoneNumber"],
          profilePhoto: value.docs[0]["profilePhoto"],
          dateOfBirth: value.docs[0]["dateOfBirth"],
          gender: value.docs[0]["gender"],
          interest: value.docs[0]["interest"],
          youSearch: value.docs[0]["youSearch"],
          howAmI: value.docs[0]["howAmI"],
          profession: value.docs[0]["profession"],
          ancestry: value.docs[0]["ancestry"],
          languages:
              List<String>.from(value.docs[0]["languages"].map((x) => x)),
          myPictures:
              List<String>.from(value.docs[0]["myPictures"].map((x) => x)),
          biography: value.docs[0]["biography"],
          socialNetworks:
              List<String>.from(value.docs[0]["socialNetworks"].map((x) => x)),
          likes: value.docs[0]["likes"],
          edadRangeDesde: value.docs[0]["edadRangeDesde"],
          edadRangeHasta: value.docs[0]["edadRangeHasta"],
          likesMe: List<String>.from(value.docs[0]["likesMe"].map((x) => x)),
          myLikes: List<String>.from(value.docs[0]["myLikes"].map((x) => x)),
          iceMe: List<String>.from(value.docs[0]["iceMe"].map((x) => x)),
          myIces: List<String>.from(value.docs[0]["myIces"].map((x) => x)),
          match: List<String>.from(value.docs[0]["match"].map((x) => x)),
          online: value.docs[0]["online"],

        );

        newUser = user;
        notifyListeners();
    });

    notifyListeners();
    return newUser;
  }


//Cargar mi usuario
Future<UserIce> loadUsersIceProfile(String email) async {
  
    await FirebaseFirestore.instance
        .collection("icebreaking_users")
        .get()
        .then((QuerySnapshot value) {
      for (var i = 0; i < value.docs.length; i++) {

        if (value.docs[i]["email"] == email) {
          UserIce user = UserIce(
            id: value.docs[i].id,
            fullName: value.docs[i]["fullName"],
            selfiePhoto: value.docs[i]["selfiePhoto"],
            email: value.docs[i]["email"],
            phoneNumber: value.docs[i]["phoneNumber"],
            profilePhoto: value.docs[i]["profilePhoto"],
            dateOfBirth: value.docs[i]["dateOfBirth"],
            gender: value.docs[i]["gender"],
            interest: value.docs[i]["interest"],
            youSearch: value.docs[i]["youSearch"],
            howAmI: value.docs[i]["howAmI"],
            profession: value.docs[i]["profession"],
            ancestry: value.docs[i]["ancestry"],
            languages:
                List<String>.from(value.docs[i]["languages"].map((x) => x)),
            myPictures:
                List<String>.from(value.docs[i]["myPictures"].map((x) => x)),
            biography: value.docs[i]["biography"],
            socialNetworks: List<String>.from(
                value.docs[i]["socialNetworks"].map((x) => x)),
            likes: value.docs[i]["likes"],
            edadRangeDesde: value.docs[i]["edadRangeDesde"],
            edadRangeHasta: value.docs[i]["edadRangeHasta"],
            likesMe: List<String>.from(value.docs[i]["likesMe"].map((x) => x)),
            myLikes: List<String>.from(value.docs[i]["myLikes"].map((x) => x)),
            iceMe: List<String>.from(value.docs[i]["iceMe"].map((x) => x)),
            myIces: List<String>.from(value.docs[i]["myIces"].map((x) => x)),
            match: List<String>.from(value.docs[i]["match"].map((x) => x)),
            online: value.docs[i]["online"],
          );

          newUser = user;
          notifyListeners();
        }
      }
    });

    notifyListeners();
    return newUser;
  }


//Cargar usuario seleccionado en un ice
  Future<UserIce> loadUsersIceProfileIce(String email) async {

    await FirebaseFirestore.instance
        .collection('icebreaking_users')
        .get()
        .then((QuerySnapshot value) async {

      for (var i = 0; i < value.docs.length; i++) {
        if (value.docs[i]["email"] == email) {
          UserIce user = UserIce(
            id: value.docs[i].id,
            fullName: value.docs[i]["fullName"],
            selfiePhoto: value.docs[i]["selfiePhoto"],
            email: value.docs[i]["email"],
            phoneNumber: value.docs[i]["phoneNumber"],
            profilePhoto: value.docs[i]["profilePhoto"],
            dateOfBirth: value.docs[i]["dateOfBirth"],
            gender: value.docs[i]["gender"],
            interest: value.docs[i]["interest"],
            youSearch: value.docs[i]["youSearch"],
            howAmI: value.docs[i]["howAmI"],
            profession: value.docs[i]["profession"],
            ancestry: value.docs[i]["ancestry"],
            languages:
                List<String>.from(value.docs[i]["languages"].map((x) => x)),
            myPictures:
                List<String>.from(value.docs[i]["myPictures"].map((x) => x)),
            biography: value.docs[i]["biography"],
            socialNetworks: List<String>.from( value.docs[i]["socialNetworks"].map((x) => x)),
            likes: value.docs[i]["likes"],
            edadRangeDesde: value.docs[i]["edadRangeDesde"],
            edadRangeHasta: value.docs[i]["edadRangeHasta"],
            likesMe: List<String>.from( value.docs[i]["likesMe"].map((x) => x)),
            myLikes: List<String>.from( value.docs[i]["myLikes"].map((x) => x)),
            iceMe: List<String>.from(value.docs[i]["iceMe"].map((x) => x)),
            myIces: List<String>.from(value.docs[i]["myIces"].map((x) => x)),
            match: List<String>.from(value.docs[i]["match"].map((x) => x)),
            online: value.docs[i]["online"],

          );

          tempUser = user;
          notifyListeners();
        }
      }
       await validarLike();
       await validarIce();
    });

    notifyListeners();
    return tempUser;
  }


//Verificar si el perfil existe
  Future<bool> verificarPerfil(String email) async {
    
    bool existe = false;

    await FirebaseFirestore.instance
        .collection('icebreaking_users')
        .where('email', isEqualTo: email)
        .get()
        .then((QuerySnapshot value) {
          existe = true;
    });

    return existe;
  }


//Actualizar todas las fotos (Perfil, selfie, lista de imagenes)
  Future<String?> uploadImage(String nombre) async {
    if (newImage == null) return null;
    isSaving = true;

    Cloudinary cloudinary =  Cloudinary(cloudinaryApiKey, cloudinaryApiSecret, cloudinaryCloudName);

    final response = await cloudinary.uploadResource(
        CloudinaryUploadResource(
            filePath: newImage!.path,
            resourceType: CloudinaryResourceType.image,
            folder: 'PhotosPofile/ProfilePhoto - $nombre',
            )
      );

    if (response.isSuccessful && response.secureUrl!.isNotEmpty) {
      urlphoto =  response.secureUrl!;
    }

    return urlphoto;
  }

  Future<String?> uploadSelfiePhoto(String nombre) async {

    if (selfiePhoto == null) return null;
    isSaving = true;

    Cloudinary cloudinary = Cloudinary(cloudinaryApiKey, cloudinaryApiSecret, cloudinaryCloudName);

    final response = await cloudinary.uploadResource(CloudinaryUploadResource(
      filePath: selfiePhoto!.path,
      resourceType: CloudinaryResourceType.image,
      folder: 'SelfiePhotos/SelfiePhoto - $nombre',
    ));

    if (response.isSuccessful && response.secureUrl!.isNotEmpty) {
      urlphoto = response.secureUrl!;
    }

    return urlphoto;
  }

  Future<List<String>?> uploadImagesList(String nombre) async {

    urlphotos = [];

    if (listaPaths.isEmpty ) return null;
    
    isSaving = true;
    Cloudinary cloudinary =  Cloudinary(cloudinaryApiKey, cloudinaryApiSecret, cloudinaryCloudName);

    List<CloudinaryResponse> responses = await cloudinary.uploadFiles(
      filePaths: listaPaths,
      resourceType: CloudinaryResourceType.image,
      folder: 'PhotosGalety/MyPhotos - $nombre',
    );

     responses.forEach((response) {
      if (response.isSuccessful == true) {
          urlphotos.add(response.secureUrl!);

      }
    });
    
    return urlphotos;
  }

  void updateSelectedImage(String path) {
    newImage = File.fromUri(Uri(path: path));
    notifyListeners();
  }

  void updateSelectedSelfiePhoto(String path) {
    selfiePhoto = File.fromUri(Uri(path: path));
    notifyListeners();
  }

  List<String>? updateSelectedImages(List<String>? lista,  List<XFile>? paths) {


    bool existe = false;

    if (paths!.isNotEmpty) {

      for (var i = 0; i < paths.length; i++) {

          if (listaPathsAnteriores.isNotEmpty){
            for (var h = 0; h < listaPaths.length; h++) {
              if (paths[i].path == listaPaths[h]) {
                existe = true;
              }
            }
          }

          if (existe == false) {
            listaPaths.add(paths[i].path);
            listaPathsAnteriores.add(paths[i].path);
            lista!.add(paths[i].path);
          }

      }
      
      
    }
    notifyListeners();
    return lista;
      
    }

}
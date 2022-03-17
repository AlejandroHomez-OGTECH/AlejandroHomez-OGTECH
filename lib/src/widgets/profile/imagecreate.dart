import 'dart:io';

import 'package:flutter/material.dart';
import 'package:icebreaking_app/src/models/models.dart';
import 'package:icebreaking_app/src/pages/pages.dart';

class ImagenProfile extends StatelessWidget{

  final UserIce user;
  // ignore: use_key_in_widget_constructors
  const ImagenProfile({required this.user});
 
  @override
  Widget build(BuildContext context) {
    

    return Container(
      alignment: Alignment.bottomRight,
      width: 140,
      height: 140,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black26, blurRadius: 15, offset: Offset(0, 15))
        ],
        shape: BoxShape.circle,
      ),
      child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(150)),
          child: getImage( user, context)),
    );
  }

  Widget getImage(UserIce? user , BuildContext context) {

    if (user!.profilePhoto == '') {
      return const Image(
          image: AssetImage('assets/profile.png'),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity);
    }

    if (user.profilePhoto.startsWith('http')) {
      return FadeInImage(
        placeholder: const AssetImage('assets/loading.gif'),
        image: NetworkImage(user.profilePhoto),
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      );
    }

    return FadeInImage(
        placeholder: const AssetImage('assets/loading.gif'),
        image: FileImage(File(user.profilePhoto)),
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity);
  }
}

class ImagenLista extends StatelessWidget {
  final String foto;
  // ignore: use_key_in_widget_constructors
  const ImagenLista({required this.foto});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      width: 140,
      height: 140,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black26, blurRadius: 15, offset: Offset(0, 15))
        ],
      ),
      child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: getImage(foto, context)),
    );
  }

  Widget getImage(String foto, BuildContext context) {

    if (foto.startsWith('http')) {
      return FadeInImage(
        placeholder: const AssetImage('assets/loading.gif'),
        image: NetworkImage(foto),
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      );
    }

    return FadeInImage(
        placeholder: const AssetImage('assets/loading.gif'),
        image: FileImage(File(foto)),
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity);
  }
}





class ImagenProfileBanner extends StatelessWidget{

  final UserIce user;
  // ignore: use_key_in_widget_constructors
  const ImagenProfileBanner({required this.user});
 
  @override
  Widget build(BuildContext context) {
    
    return Container(
      alignment: Alignment.bottomRight,
      width: double.infinity,
      height: double.infinity,
      child: getImage( user, context),
    );
  }

  Widget getImage(UserIce? user , BuildContext context) {

    if (user!.profilePhoto == '') {
      return const Image(
          image: AssetImage('assets/profile.png'),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity);
    }

    if (user.profilePhoto.startsWith('http')) {
      return FadeInImage(
        placeholder: const AssetImage('assets/loading.gif'),
        image: NetworkImage(user.profilePhoto),
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      );
    }

    return FadeInImage(
        placeholder: const AssetImage('assets/loading.gif'),
        image: FileImage(File(user.profilePhoto)),
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity);
  }
}



class SelfiePhoto extends StatelessWidget {
  final UserIce user;
  // ignore: use_key_in_widget_constructors
  const SelfiePhoto({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      width: double.infinity,
      height: 305,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: getImage(user, context)),
    );
  }

  Widget getImage(UserIce? user, BuildContext context) {
    
    if (user!.selfiePhoto! == '') {
      return const Image(
          image: AssetImage('assets/profile.png'),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity);
    }

    if (user.selfiePhoto!.startsWith('http')) {
      return FadeInImage(
        placeholder: const AssetImage('assets/loading.gif'),
        image: NetworkImage(user.selfiePhoto!),
        fit: BoxFit.contain,
        height: double.infinity,
        width: double.infinity,
      );
    }

    return FadeInImage(
        placeholder: const AssetImage('assets/loading.gif'),
        image: FileImage(File(user.selfiePhoto!)),
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity);
  }
}


import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserIce{

  UserIce({
    this.id,
    required this.fullName,
    required this.gender,
    required this.email,
    required this.youSearch,
    required this.edadRangeDesde,
    required this.edadRangeHasta,
    required this.howAmI,
    required this.profilePhoto,
    required this.dateOfBirth,
    required this.interest,
    required this.likes,
    this.selfiePhoto,
    this.phoneNumber,
    this.profession,
    this.ancestry,
    this.languages,
    this.myPictures,
    this.biography,
    this.socialNetworks,
    this.myLikes,
    this.likesMe,
    this.iceMe,
    this.myIces,
    this.match,
    this.online
  });

  String? id;
  String fullName; 
  int gender;
  String email;
  String youSearch;
  int edadRangeDesde;
  int edadRangeHasta;
  int howAmI;
  String profilePhoto;
  Timestamp dateOfBirth;
  String interest;
  String? phoneNumber;
  String? profession;
  String? ancestry;
  List<String>? languages;
  List<String>? myPictures;
  String? biography;
  List<String>? socialNetworks;
  int likes;
  String? selfiePhoto;
  List<String>? myLikes;
  List<String>? likesMe; 
  List<String>? iceMe;
  List<String>? myIces;
  List<String>? match; 
  bool? online; 

  factory UserIce.fromJson(String str) => UserIce.fromMap(json.decode(str));

  factory UserIce.fromMap(Map<String, dynamic> json, {picture}) => UserIce(
        id              : json["id"],
        fullName        : json["fullName"],
        gender          : json["gender"],
        email           : json["email"],
        youSearch       : json["youSearch"],
        edadRangeDesde  : json['edadRangeDesde'],
        edadRangeHasta  : json['edadRangeHasta'],
        howAmI          : json["howAmI"],
        profilePhoto    : json["profilePhoto"],
        dateOfBirth     : json["dateOfBirth"],
        interest        : json["interest"],
        phoneNumber     : json["phoneNumber"],
        profession      : json["profession"],
        ancestry        : json["ancestry"],
        languages       : List<String>.from(json["languages"].map((x) => x)),
        myPictures      : List<String>.from(json["myPictures"].map((x) => x)),
        biography       : json["biography"],
        socialNetworks  : List<String>.from(json["socialNetworks"].map((x) => x)),
        likes           : json["likes"],
        selfiePhoto     : json["selfiePhoto"],
        myLikes         : List<String>.from(json["myLikes"].map((x) => x)),
        likesMe         : List<String>.from(json["likesMe"].map((x) => x)),
        iceMe           : List<String>.from(json["iceMe"].map((x) => x)),
        myIces          : List<String>.from(json["myIces"].map((x) => x)),
        match           : List<String>.from(json["match"].map((x) => x)),
        online          : json["online"],


      );
}
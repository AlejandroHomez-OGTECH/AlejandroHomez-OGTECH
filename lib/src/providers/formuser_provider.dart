import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icebreaking_app/src/models/models.dart';
import 'package:provider/single_child_widget.dart';

class FormProfileProvider extends ChangeNotifier {
  
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  GlobalKey<SingleChildState> formKeySca =  GlobalKey<SingleChildState>();

  final UserIce user;
  FormProfileProvider(this.user);

  int _validarprogreso = 0;

  int get validarprogreso => _validarprogreso;
  set setValidarprogreso(int value) {
    _validarprogreso = value;
    notifyListeners();
  }


  updateName(String value) {
    user.fullName = value;
    notifyListeners();
  }

  updateGenero(int value) {
    user.gender = value;
    notifyListeners();
  }

  updateYouSearch(String value) {
    user.youSearch = value;
    notifyListeners();
  }

  updateAgeRangeDesde(int value) {
    user.edadRangeDesde = value;
    notifyListeners();
  }

  updateAgeRangeHasta(int value) {
    user.edadRangeHasta = value;
    notifyListeners();
  }

  updateHowAmI(int value) {
    user.howAmI = value;
    notifyListeners();
  }

  updatePhotoProfile(String value) {
    user.profilePhoto = value;
    notifyListeners();
  }

  updateSelfiePhoto(String value) {
    user.selfiePhoto = value;
    notifyListeners();
  }

  updateDateOfBirthday(Timestamp value) {
    user.dateOfBirth = value;
    notifyListeners();
  }

  updateInterest(String value) {
    user.interest = value;
    notifyListeners();
  }

  updatePhoneNumer(String value) {
    user.phoneNumber = value;
    notifyListeners();
  }

  updateProfession(String value) {
    user.profession = value;
    notifyListeners();
  }

  updateAncestry(String value) {
    user.ancestry = value;
    notifyListeners();
  }
  
  updateLanguages(List<String> value) {
    user.languages = value;
    notifyListeners();
  }

  updateMyPictures(List<String> value) {
    user.myPictures = value;
    notifyListeners();
  }

  updateBiography(String value) {
    user.biography = value;
    notifyListeners();
  }

  updateSocialNetWorks(List<String> value) {
    user.socialNetworks = value;
    notifyListeners();
  }

  updateLikes(int value) {
    user.likes = value;
    notifyListeners();
  }

  updateLikesMe(List<String> value) {
    user.likesMe = value;
    notifyListeners();
  }

  updateMyLikes(List<String> value) {
    user.myLikes = value;
    notifyListeners();
  }

  bool isValidFomr() {
    return formKey.currentState?.validate() ?? false;
  }
}

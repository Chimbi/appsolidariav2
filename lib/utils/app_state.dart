import 'package:appsolidariav2/model/PagerModel.dart';
import 'package:appsolidariav2/model/user.dart';
import 'package:flutter/material.dart';

class AppState with ChangeNotifier {
  AppState();

  //PAGE-1
  String dropBusinessText = null;
  String cupoText = "";
  int periodoText = 0;
  String emailText = "";
  String nameText = "";

  //PAGE-2
  String genderText = "";
  String ageText = "";

  //PAGE-3
  String cityText = "";
  String countryText = "";

  //========================== PAGE - 1 ==============================

  void setCupoText(String text) {
    cupoText = text;
    notifyListeners();
  }

  String get getCupoText => cupoText;

  void setPeriodoText(int text) {
    periodoText = text;
    notifyListeners();
  }

  int get getPeriodoText => periodoText;

  void setDropBusinessText(String text) {
    dropBusinessText = text;
    notifyListeners();
  }

  String get getDropBusinessText => dropBusinessText;

  void setEmailText(String text) {
    emailText = text;
    notifyListeners();
  }

  String get getEmailText => emailText;

  void setNameText(String text) {
    nameText = text;
    notifyListeners();
  }

  String get getNameText => nameText;

  //========================== PAGE - 2 ==============================

  void setGenderText(String text) {
    genderText = text;
    notifyListeners();
  }

  String get getGenderText => genderText;

  void setAgeText(String text) {
    ageText = text;
    notifyListeners();
  }

  String get getAgeText => ageText;

  //========================== PAGE - 3 ==============================

  void setCityText(String text) {
    cityText = text;
    notifyListeners();
  }

  String get getCityText => cityText;

  void setCountryText(String text) {
    countryText = text;
    notifyListeners();
  }

  String get getCountryText => countryText;

  //============================= CLear data===========================

  void clearData() {
    dropBusinessText = null;
    cupoText = "";
    periodoText = 0;
    genderText = "";
    ageText = "";
    cityText = "";
    countryText = "";
    emailText = "";
    nameText = "";
    notifyListeners();
  }

  //============================== Return To Object ======================

  User toUser() {
    return User(
        email: getEmailText,
        id: 1,
        name: getNameText,
        typeNeg: getDropBusinessText);
  }

  Pager toPager() {
    return Pager(
      dropBusinessText: getDropBusinessText,
      cupoText: getCupoText,
      periodoText: getPeriodoText,
      emailText: getEmailText,
      nameText: getNameText,
      genderText: getGenderText,
      ageText: getAgeText,
      cityText: getCityText,
      countryText: getCountryText,
    );
  }
}

import 'package:flutter/material.dart';

class AppState with ChangeNotifier {
  AppState();

  //PAGE-1
  String dropBusinessText = null;
  String cupoText = "";
  String periodoText = "";

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

  void setPeriodoText(String text) {
    periodoText = text;
    notifyListeners();
  }

  String get getPeriodoText => periodoText;

  void setDropBusinessText(String text) {
    dropBusinessText = text;
    notifyListeners();
  }

  String get getDropBusinessText => dropBusinessText;

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
    periodoText = "";
    genderText = "";
    ageText = "";
    cityText = "";
    countryText = "";
    notifyListeners();
  }
}

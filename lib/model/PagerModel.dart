import 'package:flutter/foundation.dart';

class Pager with ChangeNotifier{
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

  Pager({this.dropBusinessText,
    this.cupoText,
    this.periodoText,
    this.emailText,
    this.nameText,
    this.genderText,
    this.ageText,
    this.cityText,
    this.countryText
  });


}
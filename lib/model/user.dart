import 'package:flutter/foundation.dart';

class User with ChangeNotifier{
  int id;
  String name;
  String email;
  String typeNeg;
  int periodo;

  User({this.id, this.name, this.email, this.typeNeg});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
      id: parsedJson["id"],
      name: parsedJson["name"] as String,
      email: parsedJson["email"] as String,
      typeNeg: parsedJson["typeNeg"] as String,
    );
  }

  void setId(int text) {
    id = text;
    notifyListeners();
  }

  int get getId => id;


  void setName(String text) {
    name = text;
    notifyListeners();
  }

  String get getName => name;

  void setEmail(String text) {
    email = text;
    notifyListeners();
  }

  String get getEmail => email;

  void setTypeNeg(String text) {
    typeNeg = text;
    notifyListeners();
  }

  String get getTypeNeg => typeNeg;

  void setPeriodo(int text) {
    periodo = text;
    notifyListeners();
  }

  int get getPeriodo => periodo;

  @override
  String toString() {
    return '$name';
  }

  save(){
    print("User saved");
  }
}
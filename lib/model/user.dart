import 'package:flutter/foundation.dart';

class User with ChangeNotifier{
  int _id;
  String _name;
  String _email;
  String _typeNeg;
  int _periodo;


  User({int id, String name, String email, String typeNeg, int periodo}) : _id = id, _name=name, _email = email, _typeNeg=typeNeg, _periodo=periodo;

  set id(int value) {
    _id = value;
  }

  int get id => _id;

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
      id: parsedJson["id"],
      name: parsedJson["name"] as String,
      email: parsedJson["email"] as String,
      typeNeg: parsedJson["typeNeg"] as String,
    );
  }


  @override
  String toString() {
    return 'You saved a new user: $name';
  }

  save(){
    print("User saved");
  }

  String get name => _name;

  String get email => _email;

  String get typeNeg => _typeNeg;

  int get periodo => _periodo;

  set name(String value) {
    _name = value;
    notifyListeners();
  }

  set email(String value) {
    _email = value;
    notifyListeners();
  }

  set periodo(int value) {
    _periodo = value;
    notifyListeners();
  }

  set typeNeg(String value) {
    _typeNeg = value;
    notifyListeners();
  }
}
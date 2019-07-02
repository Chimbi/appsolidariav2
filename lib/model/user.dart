class User {
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


  @override
  String toString() {
    return 'You saved a new user: $name';
  }

  save(){
    print("User saved");
  }
}
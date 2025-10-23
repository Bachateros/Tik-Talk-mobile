class User {
  String name;
  String surname;
  String telNumber;
  String tgUserName;

  User({
    required this.name, 
    required this.surname, 
    required this.telNumber,
    required this.tgUserName
    });

  factory User.fromJson(Map<String,dynamic> json){
    return User(
      name : json['name'],
      surname : json['surname'],
      telNumber : json['telNumber'],
      tgUserName : json['tg_username'],
    );
  }
}

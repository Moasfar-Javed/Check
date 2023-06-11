import 'dart:convert';

List<User> userFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  String? id;
  String username;
  String email;
  String password;
  int? notesPin;

  User({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    this.notesPin,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json["_id"],
      username: json["username"],
      email: json["email"],
      password: json["password"],
      notesPin: json["notes_pin"]);

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "password": password,
        "notesPin": notesPin
      };
}

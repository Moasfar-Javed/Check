class AuthUser {
  String id;
  String username;
  String email;
  String password;

  static AuthUser? _instance;

  factory AuthUser({
    required String id,
    required String username,
    required String email,
    required String password,
  }) {
    _instance ??= AuthUser._internal(
      id: id,
      username: username,
      email: email,
      password: password,
    );
    return _instance!;
  }

  AuthUser._internal({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
  });

  factory AuthUser.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return AuthUser(
        id: json["_id"],
        username: json["username"],
        email: json["email"],
        password: json["password"],
      );
    } else {
      throw const FormatException("Invalid user data format");
    }
  }

  

  static void signOut() {
    _instance = null;
    
  }

  static AuthUser getCurrentUser(){
    return _instance!;
  }
}

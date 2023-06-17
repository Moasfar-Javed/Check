class AuthUser {
  String username;
  String email;
  String notesPin;

  static AuthUser? _instance;

  factory AuthUser({
    required String username,
    required String email,
    required String notesPin,
  }) {
    _instance ??= AuthUser._internal(
      username: username,
      email: email,
      notesPin: notesPin,
    );
    return _instance!;
  }

  AuthUser._internal({
    required this.username,
    required this.email,
    required this.notesPin
  });

  factory AuthUser.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return AuthUser(
        username: json["username"],
        email: json["email"],
        notesPin: json["pin"]
      );
    } else {
      throw const FormatException("Invalid user data format");
    }
  }

  Map<String, dynamic> toJson() => {
        "email": email,
        "username": username,
        "pin": notesPin,
      };

  static void signOut() {
    _instance = null;
  }

  static AuthUser getCurrentUser() {
    return _instance!;
  }
}

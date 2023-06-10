class AuthUser {
  String username;
  String email;

  static AuthUser? _instance;

  factory AuthUser({
    required String username,
    required String email,
  }) {
    _instance ??= AuthUser._internal(
      username: username,
      email: email,
    );
    return _instance!;
  }

  AuthUser._internal({
    required this.username,
    required this.email,
  });

  factory AuthUser.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return AuthUser(
        username: json["username"],
        email: json["email"],
      );
    } else {
      throw const FormatException("Invalid user data format");
    }
  }

  Map<String, dynamic> toJson() => {
        "email": email,
        "username": username,
      };

  static void signOut() {
    _instance = null;
  }

  static AuthUser getCurrentUser() {
    return _instance!;
  }
}

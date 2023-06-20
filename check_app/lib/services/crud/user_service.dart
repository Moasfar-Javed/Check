import 'dart:convert';
import 'package:check_app/firebase_options.dart';
import 'package:check_app/services/auth_user.dart';
import 'package:check_app/services/base_client.dart';
import 'package:check_app/services/defined_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class UserService {
  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  Future<bool> get currentUser async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      return false;
    } else {
      final user = await getUser(email: firebaseUser.email!);
      AuthUser(
          username: user.username, email: user.email, notesPin: user.notesPin);
      return true;
    }
  }

  Future<void> signInUser(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email' || e.code == 'wrong-password' || e.code == 'user-not-found') {
        throw InvalidLoginException();
      }
    }
    final user = await getUser(email: email);
    AuthUser(
        username: user.username, email: user.email, notesPin: user.notesPin);
  }

  Future<AuthUser> getUser({required String email}) async {
    var response =
        await BaseClient().getUserApi('/users?email=$email');
    if (response == null) throw ApiException;
    List<dynamic> jsonResponse = jsonDecode(response);

    if (jsonResponse.isEmpty) NoItemsException;
    AuthUser user = AuthUser.fromJson(jsonResponse[0]);
    return user;
  }

  Future<void> addUser({
    required String username,
    required String email,
    required String password,
  }) async {
    const pin = "1234";
    final Map<String, dynamic> requestBody = {
      "username": username,
      "email": email,
      "pin": pin
    };

    try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
        } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email' ) {
        throw InvalidLoginException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUse();
      } else if (e.code == 'weak-password') {
        throw WeakPassword();
      }
    }
    try {
      var response = await BaseClient().postUserApi(
        '/users',
        requestBody,
      );
      if (response == null) throw NoItemsException();
    } catch (e) {
      print('API request error: $e');
    }
  }

  Future<void> puUser({
    required String username,
    required String pin,
  }) async {
    final Map<String, dynamic> requestBody = {"username": username, "pin": pin};

    try {
      var response = await BaseClient().putUserApi(
        '/users?email=${AuthUser.getCurrentUser().email}',
        requestBody,
      );
      if (response == null) throw NoItemsException();
    } catch (e) {
      print('API request error: $e');
    }
  }

  Future<void> changePassword() async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: AuthUser.getCurrentUser().email);
  }

  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
      AuthUser.signOut();
    }
  }
}

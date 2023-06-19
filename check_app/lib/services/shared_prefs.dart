import 'package:check_app/services/auth_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static Future<void> addToPrefs({required String pin}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(
        'check-app-note-key:${AuthUser.getCurrentUser().email}', pin);
  }

    static Future<String?> readFromPrefs() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(
        'check-app-note-key:${AuthUser.getCurrentUser().email}');
  }

  
  static Future<void> delFromPrefs({required String pin}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove(
        'check-app-note-key:${AuthUser.getCurrentUser().email}');
  }  
}

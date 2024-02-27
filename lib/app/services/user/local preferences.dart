import 'package:shared_preferences/shared_preferences.dart';

class LocalPreferences {
  static Future<void> setUserEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", email);
  }

  static Future<void> setUserPassword(String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("password", password);
  }

  static Future<String> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString("email");
    if (email != null) {
      return email;
    } else {
      return "";
    }
  }

  static Future<String> getUserPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var password = prefs.getString("password");
    if (password != null) {
      return password;
    } else {
      return "";
    }
  }

  static Future<bool> isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString("email");
    var password = prefs.getString("password");
    if (email != null && password != null) {
      return true;
    } else {
      return false;
    }
  }

  static void clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    // BasicAPI.setEnvironment();
  }
}

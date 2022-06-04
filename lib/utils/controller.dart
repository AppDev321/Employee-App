import 'package:shared_preferences/shared_preferences.dart';

class Controller {
  final String auth_token = "auth_token";
  final String loginRemember = "login_remember";

  Future<void> setAuthToken(String auth_token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.auth_token, auth_token);
  }

  deleteUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(this.auth_token);
  }

  Future<String?> getAuthToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? auth_token;
    auth_token = pref.getString(this.auth_token) ?? null;
    return auth_token;
  }


  Future<void> setEmail(String emaiID) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.auth_token, auth_token);
  }
  Future<void> setPassword(String emaiID) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.auth_token, auth_token);
  }


  Future<void> setRememberLogin(bool isRemember) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(this.loginRemember, isRemember);
  }
  Future<bool> getRememberLogin() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    bool isRemember;
    isRemember = pref.getBool(this.loginRemember) ?? false;
    return isRemember;
  }


}
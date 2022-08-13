import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hnh_flutter/widget/custom_text_widget.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/login/login.dart';

class Controller {
  final String auth_token = "auth_token";
  final String loginRemember = "login_remember";
  static const double leftCardColorMargin = 5;

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


  String getConvertedDate(DateTime now)
  {
    //var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    return formattedDate;
  }

  void showToastMessage(BuildContext context, String text) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(text),
        action: SnackBarAction(
            label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
  bool validatePassword(String value) {
    RegExp regex =
    RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value.isEmpty) {
      return false;
    } else {
      if (!regex.hasMatch(value)) {
        return false;
      } else {
        return true;
      }
    }
  }

  void showMessageDialog(String msg,String title) {
 Get.dialog(
      AlertDialog(
        title: CustomTextWidget(text:title,fontWeight: FontWeight.bold,),
        content: CustomTextWidget(text:msg),

       /* actions: [
          TextButton(
            child: const Text("Close"),
            onPressed: () {

                    Get.back();

              },
          ),
        ],*/
      ),
    );


  }





void logoutUser()
{
  Controller controller = Controller();
  controller.setRememberLogin(false);
  Get.offAll(()=> LoginClass());

}




  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Simple Alert"),
      content: Text("This is an alert message."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }



}
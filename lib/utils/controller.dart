import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hnh_flutter/widget/custom_text_widget.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../custom_style/colors.dart';
import '../pages/login/login.dart';

enum ChatMessageType { text, audio, image, video, file }

class Controller {
  static const String appBaseURL = "http://vmi808920.contaboserver.net/api";
 //"http://192.168.18.69:8000/api";
     // "http://afjdemo.hnhtechpk.com/api";

  //  "http://afjdev.hnhtechpk.com/api";

static const String webSocketURL  = "ws://vmi808920.contaboserver.net:6001/video-call?token=";
//static const String webSocketURL  = "ws://192.168.18.69:6001/video-call?token=";
 //static const String webSocketURL  = "ws://192.168.18.69:6001/mobile?token=";

  final String auth_token = "auth_token";
  final String loginRemember = "login_remember";
  static const double leftCardColorMargin = 5;
  static const double roundCorner = 5;
  final String fcm_screen = "fcm_screen";
  final String notificationBroadCast = "notificationBroadCast";
  final String fcmMsgValue = "fcm_msg_key";
  final String userKey = "user_key";
  final defaultPic = "http://simpleicon.com/wp-content/uploads/account.png";
  final String emailPref="emailPref";
  final String passPref="passPref";
  final String fingerPrintPref = "finger_pref";
  static const PREF_KEY_THEME = "pref_key_theme";
  static const PREF_KEY_USER_OBJECT = "pref_key_user_object";


  final String socketMessageBroadCast = "socketMessageBroadCast";

  setTheme(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(PREF_KEY_THEME, value);
  }

  getTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(PREF_KEY_THEME) ?? false;
  }

  Future<void> setFCMScreen(String screenName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.fcm_screen, screenName.toLowerCase());
  }

  Future<String> getFCMScreen() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String screenName;
    screenName = pref.getString(this.fcm_screen) ?? '';
    return screenName;
  }

  Future<void> setUserProfilePic(String userPicUrl) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.userKey, userPicUrl);
  }

  Future<String> getUserProfilePic() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String screenName;
    screenName = pref.getString(this.userKey) ?? '';
    return screenName;
  }

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

    prefs.setString( emailPref,emaiID);
  }

  Future<void> setPassword(String pass) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(passPref, pass);
  }

  Future<String> getEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return  prefs.getString(emailPref)?? "";
  }

  Future<String> getPassword() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString( passPref)?? "";
  }



  Future<void> setBiometericStatus(bool isRemember) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(this.fingerPrintPref, isRemember);
  }

  Future<bool> getBiometericStatus() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    bool isRemember;
    isRemember = pref.getBool(this.fingerPrintPref) ?? false;
    return isRemember;
  }

     getObjectPreference(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString(key).toString());
  }

  saveObjectPreference(String key,  value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
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

  String getConvertedDate(DateTime now) {
    //var now = new DateTime.now();
    var formatter =  DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    return formattedDate;
  }

  String getConvertedTime(DateTime now) {
    //var now = new DateTime.now();
    var formatter =  DateFormat('HH:mm a');
    String formattedDate = formatter.format(now);
    return formattedDate;
  }

  void showToastMessage(BuildContext context, String text) {
    Get.snackbar('Alert', text,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.black,
        colorText: Colors.white);
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

  void showMessageDialog(BuildContext context,String msg, String title,VoidCallback? callback) {
    Get.dialog(
      AlertDialog(
        title: CustomTextWidget(
          text: title,
          fontWeight: FontWeight.bold,
        ),
        content: CustomTextWidget(text: msg),
        actions: [
          TextButton(
              child: const Text("Yes"),
              onPressed: callback
          ),
          TextButton(
            child: const Text("No"),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop('dialog');
            },
          ),
        ],
      ),
    );
  }

  void logoutUser() {
    Controller controller = Controller();
    controller.setRememberLogin(false);
    Get.offAll(() => LoginClass());
  }

  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = ElevatedButton(
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

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }

  String differenceFormattedString(int minute) {
    try {
      DateTime now = DateTime.now();

      Duration difference = Duration(minutes: minute);

      final today =
      DateTime(now.year).add(difference).subtract(const Duration(days: 1));

      //return '${today.day} Days ${today.hour} Hours ${today.minute} Min';

      if (today.hour > 0)
        return '${today.hour}h, ${today.minute}min';
      else
        return '${today.minute}min';
    } catch (e) {
      return '';
    }
  }

  String getServerDateFormated(String serverDate) {
    DateTime requestDateFormate =
    new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(serverDate);
    var dateFormat = DateFormat('dd-MMM-yyyy');
    var startDate =
    dateFormat.format(DateTime.parse(requestDateFormate.toString()));
    return startDate;
  }

  String convertStringDate(String jsonDate, String parsingType) {
    DateTime parseDate = new DateFormat("dd-MMM-yyyy").parse(jsonDate);
    var dateFormat = DateFormat('E MMM dd yyyy');

    switch (parsingType) {
      case "month":
        dateFormat = DateFormat('MMM');
        break;
      case "date":
        dateFormat = DateFormat('dd');
        break;
      case "year":
        dateFormat = DateFormat('yyyy');
        break;
      case "day":
        dateFormat = DateFormat('E');
        break;
    }

    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = dateFormat;
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  String capitalize(String str) => str[0].toUpperCase() + str.substring(1);

  showConfirmationMsgDialog(BuildContext context, String title, String msg,
      String positiveButtonLabel, ValueChanged<bool> OnPostiveButtonClick) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: CustomTextWidget(
            text: title,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[CustomTextWidget(text: msg)],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: CustomTextWidget(
                text: positiveButtonLabel,
                color: primaryColor,
              ),
              onPressed: () {
                OnPostiveButtonClick(true);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: CustomTextWidget(text: "Cancel"),
              onPressed: () {
                OnPostiveButtonClick(false);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Color getThemeTextColor() {
    return (Get.isDarkMode ? primaryColor : blackThemeTextColor);
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }
}
enum FingerPrintOption {
  ENABLE,
  DISABLE
}


enum Screen {
  PROFILE,
  SHIFT,
  OVERTIME,
  LEAVE,
  REPORT,
  AVAILABILITY,
  DASHBOARD,
  NULL
}

extension ScreenNameExtention on Screen {
  String get name => describeEnum(this);

  String get displayTitle {
    switch (this) {
      case Screen.PROFILE:
        return 'Profile';
      case Screen.REPORT:
        return 'Report';
      case Screen.SHIFT:
        return 'Shift';
      case Screen.LEAVE:
        return 'Leave';
      case Screen.OVERTIME:
        return 'Overtime';
      case Screen.AVAILABILITY:
        return 'Availability';
      case Screen.DASHBOARD:
        return 'Dashboard';
      default:
        return '';
    }
  }
}


enum SocketMessageType {

  //From App to Web
  StartCall,
  CreateOffer,
  AnswerCall,
  SendIceCandidate,
  RejectCall,
  CallEnd,
  Send,

  //From Web to App

  CallResponse,
  AnswerReceived,
  OfferReceived,
  CallReject,
  CallClosed,
  ICECandidate,
  CallAlreadyAnswer,
  Received,

}

extension MessageTypeExtention on SocketMessageType {
  String get name => describeEnum(this);

  String get displayTitle {
    switch (this) {
      case SocketMessageType.StartCall:
        return 'is-client-ready';
      case SocketMessageType.CreateOffer:
        return 'store_offer';
      case SocketMessageType.AnswerCall:
        return 'send_answer';
      case SocketMessageType.SendIceCandidate:
        return 'store_candidate';
      case SocketMessageType.RejectCall:
        return 'offer_reject';
      case SocketMessageType.CallEnd:
        return 'call_end';
      case SocketMessageType.Send:
        return 'send';



      case SocketMessageType.CallResponse:
        return 'call_response';
      case SocketMessageType.AnswerReceived:
        return 'answer';
      case SocketMessageType.OfferReceived:
        return 'offer_received';
      case SocketMessageType.CallReject:
        return 'call_reject';
      case SocketMessageType.CallClosed:
        return 'call_closed';
      case SocketMessageType.ICECandidate:
        return 'ice_receive_candidate';
      case SocketMessageType.CallAlreadyAnswer:
        return 'call_already_answered';
      case SocketMessageType.Received:
        return 'received';

      default:
        return '';
    }
  }
}
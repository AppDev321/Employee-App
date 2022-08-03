
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:hnh_flutter/pages/login/login.dart';
import 'package:hnh_flutter/pages/shift/shift_list.dart';
import 'package:hnh_flutter/provider/navigation_provider.dart';
import 'package:hnh_flutter/view_models/login_view_model.dart';
import 'package:hnh_flutter/view_models/shift_list_vm.dart';
import 'package:hnh_flutter/webservices/APIWebServices.dart';
import 'package:provider/provider.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

import 'custom_style/strings.dart';
import 'notification/firebase_notification.dart';
import 'utils/controller.dart';


//Global app initialization

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',

    importance: Importance.high,
    playSound: true
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Notification Message :  ${message.messageId}');
 // LocalNotificationService.createandDisplayNotification(message);
}



Future<String> storeFCMTokenOnServer(String url, Map jsonMap) async {
print("url $jsonMap");
  Controller controller = Controller();
  String? userToken = await controller.getAuthToken();

  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
  request.headers.set('content-type', 'application/json');
  request.headers.set('Accept', 'application/json');
  request.headers.set('Authorization', 'Bearer ${userToken}');
  request.add(utf8.encode(json.encode(jsonMap)));
  HttpClientResponse response = await request.close();
  String reply = await response.transform(utf8.decoder).join();
  print("url -response: $reply");
  httpClient.close();
  return reply;
}

 String? fcmToken ="";
String? platFormType ="android";



void main() async{
  //runApp(CameraWidget());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //when app is in backgorund
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  fcmToken = await FirebaseMessaging.instance.getToken();
  if (Platform.isIOS) {
    platFormType = "IOS";
  } else {
    platFormType = "Android";
  }

  LocalNotificationService.initializeNotification();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);


  //For IOS
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );


  runApp(MaterialApp(

    initialRoute: 'splash',
    title: "Pick Image Camera",
    debugShowCheckedModeBanner: false,
    routes: {
      'splash': (context) => MyApp(),
      'login': (context) => LoginClass()
    },
  ));
}
Future<bool> checkPassPreference() async {
  Controller controller = Controller();
  bool isRememmber = await controller.getRememberLogin();
  if (isRememmber) {
    String? isAuth = await controller.getAuthToken();
    if (isAuth != null) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}

class MyApp extends StatelessWidget {

  Map<String,String> map = {
    'device_type': 'android',
    'fcm_token':fcmToken!
  };

var api =APIWebService();
  late Widget routeClass;

  Future<bool> checkPassPreference() async {
    Controller controller = Controller();
    bool isRememmber = await controller.getRememberLogin();
    if (isRememmber) {
      String? isAuth = await controller.getAuthToken();
      if (isAuth != null) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {

    Widget example5 = SplashScreenView(
      navigateRoute:
      FutureBuilder<bool>(
          future: checkPassPreference(),
          builder: (context, snapshot)
          {
            if(snapshot.hasData){
              if(snapshot.data!)
              {
                return ShiftList();
              }
              else
              {
                return LoginClass();
              }
            }
            return Center();
          }),
      duration: 3000,
      imageSize: 300,
      imageSrc: ConstantData.logoIconPath,
      backgroundColor: Colors.white,
    );
      var re =  MultiProvider(providers: [
        ChangeNotifierProvider(create: (context) => NavigationProvider()),
      ],
    child:
    GetMaterialApp(
      title:  ConstantData.appName,
      home: example5,
      debugShowCheckedModeBanner: false,
    )
);
    return re ;
  }




}



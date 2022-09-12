import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:hnh_flutter/pages/dashboard/dashboard.dart';
import 'package:hnh_flutter/pages/leave/leave_listing.dart';
import 'package:hnh_flutter/pages/login/login.dart';
import 'package:hnh_flutter/pages/shift/shift_list.dart';
import 'package:hnh_flutter/provider/navigation_provider.dart';
import 'package:hnh_flutter/view_models/login_view_model.dart';
import 'package:hnh_flutter/view_models/shift_list_vm.dart';
import 'package:hnh_flutter/webservices/APIWebServices.dart';
import 'package:provider/provider.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

import 'bloc/connected_bloc.dart';
import 'custom_style/colors.dart';
import 'custom_style/strings.dart';
import 'notification/firebase_notification.dart';
import 'utils/controller.dart';

//Global app initialization

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', 'High Importance Notifications',
    importance: Importance.high, playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final FirebaseMessaging fm = FirebaseMessaging.instance;

/*
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Notification Message :  ${message.data.toString()}');
}
*/

String? fcmToken = "";
String? platFormType = "android";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  fcmToken = await FirebaseMessaging.instance.getToken();


  if (Platform.isIOS) {
    platFormType = "IOS";
  } else {
    platFormType = "Android";
  }

  LocalNotificationService.initializeNotification();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  //For IOS
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );




  runApp(

      //For internet connection states
      BlocProvider(
    create: (context) => ConnectedBloc(),
    child: MaterialApp(
      initialRoute: 'splash',
      title: ConstantData.appName,
      debugShowCheckedModeBanner: false,
      routes: {
        'splash': (context) => MyApp(),
        'login': (context) => LoginClass()
      },
    ),
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
  Map<String, String> map = {'device_type': 'android', 'fcm_token': fcmToken!};

  var api = APIWebService();
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
      navigateRoute: FutureBuilder<bool>(
          future: checkPassPreference(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!) {
                return Dashboard();
              } else {
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
    var re = MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => NavigationProvider()),
        ],
        child: GetMaterialApp(
          title: ConstantData.appName,
          home: example5,
          debugShowCheckedModeBanner: false,
          /*
      theme: ThemeData(
        fontFamily: 'Raleway',
        primaryColor: primaryColor,
    primarySwatch: primaryColorTheme,



      ),*/

          /* light theme settings */
          theme: ThemeData(
            fontFamily: 'Raleway',
            primarySwatch: primaryColorTheme,
            primaryColor: primaryColor,
          ),
          themeMode: ThemeMode.light,
        ));
    return re;
  }
}

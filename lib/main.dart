import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:hnh_flutter/pages/dashboard/dashboard.dart';
import 'package:hnh_flutter/pages/login/login.dart';
import 'package:hnh_flutter/provider/navigation_provider.dart';
import 'package:hnh_flutter/provider/theme_provider.dart';
import 'package:hnh_flutter/view_models/dashbboard_vm.dart';
import 'package:hnh_flutter/webservices/APIWebServices.dart';
import 'package:provider/provider.dart';

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

String? fcmToken = "";
String? platFormType = "android";

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  //For https certification SSL handshake
  HttpOverrides.global = MyHttpOverrides();

  fcmToken = await FirebaseMessaging.instance.getToken();
/*  if (Platform.isIOS) {
    platFormType = "IOS";
  } else {
    platFormType = "Android";
  }*/

  LocalNotificationService.initializeNotification();
  if (!kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  }
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

  var dashBoardViewModel = DashBoardViewModel();
  dashBoardViewModel.initFireBaseConfig().then((value)  {
    runApp(
      //For internet connection states
        BlocProvider(
          create: (context) => ConnectedBloc(),
          child: MaterialApp(
            initialRoute: 'splash',
            title: ConstantData.appName,
            debugShowCheckedModeBanner: false, //for tablet desing
            routes: {
              'splash': (context) => MyApp(),
              'login': (context) => LoginClass()
            },
          ),
        ));
  });

}


class MyApp extends StatelessWidget {
  Map<String, String> map = {'device_type': 'android', 'fcm_token': fcmToken!};

  var api = APIWebService();
  late Widget routeClass;


  Future<bool> checkPassPreference() async {
    final controller = Controller();
    final isRemembered = await controller.getRememberLogin();
    return isRemembered
        ? await controller.getAuthToken() != null
        : false;
  }


  @override
  Widget build(BuildContext context) {
    var multiProvider = MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => NavigationProvider()),
          ChangeNotifierProvider(create: (context) => ThemeModel()),
        ],
        child: Consumer<ThemeModel>(
            builder: (context, ThemeModel themeNotifier, child) {
          primaryColor =
              themeNotifier.isDark ? primaryDarkColor : primaryBlueColor;
          cardThemeBaseColor =
              themeNotifier.isDark ? Colors.black : Colors.white;
          borderColor = themeNotifier.isDark
              ? blackThemeTextColor
              : textFielBoxBorderColor;
          return GetMaterialApp(
            title: ConstantData.appName,
            home:

            FutureBuilder<bool>(
              future: checkPassPreference(),
              builder: (context, snapshot) => snapshot.hasData ? snapshot.data!
                  ? Dashboard()
                  : LoginClass():Container(color: Colors.white,),
            ),



            debugShowCheckedModeBanner: false,
            theme: themeNotifier.isDark ? _darkTheme : _lightTheme,
            themeMode: themeNotifier.isDark ? ThemeMode.dark : ThemeMode.light,
          );
        }));
    return multiProvider;
  }

  final ThemeData _darkTheme = ThemeData(
    fontFamily: 'Raleway',
    accentColor: primaryDarkColor,
    brightness: Brightness.dark,
    primaryColor: primaryDarkColor,
    primarySwatch: primaryColorDarkTheme,
  );

  final ThemeData _lightTheme = ThemeData(
    fontFamily: 'Raleway',
    accentColor: primaryColor,
    brightness: Brightness.light,
    primaryColor: primaryColor,
    primarySwatch: primaryColorTheme,
  );
}

import 'package:flutter/material.dart';
import 'package:hnh_flutter/pages/imagepicker.dart';
import 'package:hnh_flutter/pages/location/location_background_service.dart';

import 'package:hnh_flutter/pages/login.dart';
import 'package:hnh_flutter/pages/maplocation.dart';
import 'package:splash_screen_view/SplashScreenView.dart';


void main() {
  //runApp(CameraWidget());
  runApp(
      MaterialApp(
        title: "Pick Image Camera",
        home: MapLocation() ,
      )
  );
}

class MyApp extends StatelessWidget {
  final String logoIconPath = "assets/icons/ic_launcher.png";

  @override
  Widget build(BuildContext context) {

    /// Logo with Normal Text example
    Widget example5 = SplashScreenView(
      navigateRoute: LoginClass(),
      duration: 3000,
      imageSize: 130,
      imageSrc: logoIconPath,
      text: "Splash Screen",
      textType: TextType.NormalText,
      textStyle: TextStyle(
        fontSize: 30.0,
      ),
      backgroundColor: Colors.white,
    );

    return MaterialApp(
      title: 'HNH App',
      home: example5,
    );
  }
}

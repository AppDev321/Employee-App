import 'package:flutter/material.dart';
import 'package:hnh_flutter/pages/splash.dart';
import 'package:splash_screen_view/SplashScreenView.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// Normal Logo Splash screen
    Widget example1 = SplashScreenView(
      navigateRoute: SplashScreenClass(),
      duration: 3000,
      imageSize: 130,
            imageSrc: "assets/icons/ic_launcher.png",
      backgroundColor: Colors.white,
    );

    /// Logo with animated Colorize text
    Widget example2 = SplashScreenView(
      navigateRoute: SplashScreenClass(),
      duration: 5000,
      imageSize: 130,
      imageSrc: "assets/icons/ic_launcher.png",
      text: "Splash Screen",
      textType: TextType.ColorizeAnimationText,
      textStyle: TextStyle(
        fontSize: 40.0,
      ),
      colors: [
        Colors.purple,
        Colors.blue,
        Colors.yellow,
        Colors.red,
      ],
      backgroundColor: Colors.white,
    );

    /// Logo with Typer Animated Text example
    Widget example3 = SplashScreenView(
      navigateRoute: SplashScreenClass(),
      duration: 3000,
      imageSize: 130,
      pageRouteTransition: PageRouteTransition.Normal,
            imageSrc: "assets/icons/ic_launcher.png",
      speed: 100,
      text: "Splash Screen",
      textType: TextType.TyperAnimatedText,
      textStyle: TextStyle(
        fontSize: 30.0,
      ),
      backgroundColor: Colors.white,
    );

    /// Logo with Scale Animated Text example
    Widget example4 = SplashScreenView(
      navigateRoute: SplashScreenClass(),
      duration: 3000,
      imageSize: 130,
            imageSrc: "assets/icons/ic_launcher.png",
      text: "Splash Screen",
      textType: TextType.ScaleAnimatedText,
      textStyle: TextStyle(
        fontSize: 30.0,
      ),
      backgroundColor: Colors.white,
    );

    /// Logo with Normal Text example
    Widget example5 = SplashScreenView(
      navigateRoute: SplashScreenClass(),
      duration: 3000,
      imageSize: 130,
            imageSrc: "assets/icons/ic_launcher.png",
      text: "Splash Screen",
      textType: TextType.NormalText,
      textStyle: TextStyle(
        fontSize: 30.0,
      ),
      backgroundColor: Colors.white,
    );

    return MaterialApp(
      title: 'Splash screen Demo',
      home: example5,
    );
  }
}
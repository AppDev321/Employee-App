import 'package:flutter/material.dart';


import 'components/body.dart';

class SettingScreen extends StatelessWidget {
  static String routeName = "/profile";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Settings"),
      ),
      body:
      Body(),

    );
  }
}

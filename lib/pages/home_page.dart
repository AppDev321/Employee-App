import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hnh_flutter/repository/model/request/login_data.dart';
import 'package:hnh_flutter/repository/retrofit/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../custom_style/dialog_builder.dart';
import '../custom_style/progress_hud.dart';
import '../custom_style/strings.dart';
import '../repository/model/response/login_api_response.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageStateful();
}

class HomePageStateful extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}

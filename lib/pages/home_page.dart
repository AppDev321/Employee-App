import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hnh_flutter/pages/vehicle/vehicle_list.dart';
import 'package:hnh_flutter/repository/model/request/login_data.dart';
import 'package:hnh_flutter/repository/retrofit/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../custom_style/dialog_builder.dart';
import '../custom_style/progress_hud.dart';
import '../custom_style/strings.dart';
import '../repository/model/response/login_api_response.dart';
import '../widget/navigation_drawer_widget.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageStateful();
}

class HomePageStateful extends State<HomePage> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(ConstantData.appName),
      ),
      drawer: NavigationDrawerWidget(),

    );
  }
}

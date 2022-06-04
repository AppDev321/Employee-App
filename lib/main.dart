import 'package:flutter/material.dart';
import 'package:hnh_flutter/pages/home_page.dart';
import 'package:hnh_flutter/pages/login/login.dart';
import 'package:hnh_flutter/provider/navigation_provider.dart';
import 'package:hnh_flutter/view_models/login_view_model.dart';
import 'package:hnh_flutter/view_models/vehicle_inspection_list_vm.dart';
import 'package:hnh_flutter/view_models/vehicle_list_vm.dart';
import 'package:provider/provider.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

import 'pages/location/maplocation.dart';
import 'pages/vehicle/vehicle_list.dart';
import 'utils/controller.dart';

void main() {
  //runApp(CameraWidget());

  runApp(MaterialApp(
    initialRoute: 'splash',
    debugShowCheckedModeBanner: false,
    title: "Pick Image Camera",
    routes: {
      'splash': (context) => MyApp(),
      'login': (context) => LoginClass()
    },
  ));
}

class MyApp extends StatelessWidget {
  final String logoIconPath = "assets/icons/ic_launcher.png";
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
    /// Logo with Normal Text example
    Widget example5 = SplashScreenView(
      navigateRoute:
      FutureBuilder<bool>(
          future: checkPassPreference(),
          builder: (context, snapshot)
          {
            if(snapshot.hasData){
              if(snapshot.data!)
                {
                  return VehicleList();
                }
              else
                {

                /*return  ChangeNotifierProvider(
                    create: (context) => LoginViewModel(),
                    child: LoginClass(),
                  );*/
                  return LoginClass();
                }
            }
            return LoginClass();
          }),
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

    return
      MultiProvider(providers: [
          ChangeNotifierProvider( create: (context) => LoginViewModel()),
          ChangeNotifierProvider( create: (context) => VehicleListViewModel()),
          ChangeNotifierProvider(create: (context) => NavigationProvider()),
          ChangeNotifierProvider(create: (context) => VehicleInspectionListViewModel())
      ],
      child:
      MaterialApp(
      title: 'HNH App',
      home: example5,
    )
      );
  }
}

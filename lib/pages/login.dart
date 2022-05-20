import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hnh_flutter/pages/home_page.dart';
import 'package:hnh_flutter/pages/maplocation.dart';
import 'package:hnh_flutter/repository/model/request/login_data.dart';
import 'package:hnh_flutter/repository/retrofit/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../custom_style/colors.dart';
import '../custom_style/dialog_builder.dart';
import '../custom_style/progress_hud.dart';
import '../custom_style/strings.dart';
import '../repository/model/response/login_api_response.dart';

class LoginClass extends StatefulWidget {
  const LoginClass({Key? key}) : super(key: key);

  @override
  State<LoginClass> createState() => LoginClassStateful();
}

class LoginClassStateful extends State<LoginClass> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  DialogBuilder? pr;
  static const String loginText = 'Login';
  static const String signUpText = "Sign Up";
  static const String forgotText = "Forgot Password?";
  static const bool showExtraViews = false;
  bool isApiCallProcess = false;

  bool pressed = false;
  bool isDataReceived = false;
  BuildContext? _dismissingContext;

  @override
  void initState() {
    super.initState();
     setState(() {
       isDataReceived = false;
       pressed = false;

      });


  }

  @override
  Widget build(BuildContext context) {
    pr = new DialogBuilder(context);
    pr?.initiateLDialog('Pleas wait..');

    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  Widget _uiSetup(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color:primaryColor),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(left: 35, top: 130),
              child: Text(
                'HNH Login',
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.3,
                      right: 35,
                      left: 35),
                  child: Column(
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: new InputDecoration(
                            filled: true,
                            fillColor: Colors.green.shade100,
                            hintText: 'Username',
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Colors.green.shade100,
                                      width: 5.0)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Colors.green.shade100,
                                      width: 5.0))),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.green.shade100,
                              hintText: 'Password',
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Colors.green.shade100,
                                      width: 5.0)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Colors.green.shade100,
                                      width: 5.0))),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: ElevatedButton(
                              child: const Text(loginText),
                            onPressed: () {
                              print(nameController.text);
                              print(passwordController.text);
                              _onLoginButtonPress(context);
                            },
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size(300, 50),
                                primary: Colors.black54,
                                padding: EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32.0)),
                                textStyle: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal)),
                          )),
                      pressed ? _buildBody(context) : SizedBox(),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  void _onLoginButtonPress(BuildContext context) async {
    pr?.showLoadingDialog();
    setState(() {
      //  isApiCallProcess = true;
      pressed = true;
    });
  }

  FutureBuilder<LoginApiResponse> _buildBody(BuildContext context) {
    LoginRequestBody
        requestBody = //LoginRequestBody( email: nameController.text, password: passwordController.text);
        LoginRequestBody(email: "mohsin121@afj.com", password: "123456");

    final client = ApiClient(Dio(BaseOptions(
        contentType: "application/json",
        headers: {'Content-Type': 'application/json'
        })));
    return FutureBuilder<LoginApiResponse>(
      future: client.login(requestBody),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {

          pr?.hideOpenDialog();

          if (snapshot.hasData ) {
            final LoginApiResponse posts = snapshot.data!;
            saveUserToken(posts.token);
            var token = getUserToken();
            return Center();
          } else {
            return Center(
              child: Text(
                'Wrong Email/Password',
                textAlign: TextAlign.center,
                textScaleFactor: 1.3,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          }
        } else {
          return Center();
        }
      },
    );
  }

  saveUserToken(String? token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(ConstantData.pref_user_token, token!);

    setState(() {
      isDataReceived =true;
      pressed = false;

    });
    //Move to next location

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  MapLocation()),
    );
  }

  Future<String?> getUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(ConstantData.pref_user_token);
    //print('value:$value');
  }

  deleteUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(ConstantData.pref_user_token);
  }
}

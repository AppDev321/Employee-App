import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hnh_flutter/custom_style/colors.dart';
import 'package:hnh_flutter/custom_style/strings.dart';
import 'package:hnh_flutter/repository/model/request/login_data.dart';
import 'package:hnh_flutter/repository/model/response/login_response.dart';
import 'package:hnh_flutter/repository/retrofit/api_client.dart';

import '../custom_style/progress_hud.dart';

class LoginClass extends StatefulWidget {
  const LoginClass({Key? key}) : super(key: key);

  @override
  State<LoginClass> createState() => LoginClassStateful();
}

class LoginClassStateful extends State<LoginClass> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  static const String loginText = 'Login';
  static const String signUpText = "Sign Up";
  static const String forgotText = "Forgot Password?";
  static const bool showExtraViews = false;
  bool isApiCallProcess = false;

  bool pressed = false;
  @override
  void initState() {
    super.initState();
      setState(() {
        pressed = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }
    Widget _uiSetup(BuildContext context) {
      return Container(
        decoration: BoxDecoration(color: Colors.green),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body:

          Stack(
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
                        top: MediaQuery
                            .of(context)
                            .size
                            .height * 0.3,
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
                                setState(() {
                                //  isApiCallProcess = true;
                                  pressed = true;
                                });

                              },
                              style: ElevatedButton.styleFrom(
                                  minimumSize: Size(300, 50),
                                  primary: Colors.black54,
                                  padding: EdgeInsets.all(10),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          32.0)),
                                  textStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal)),
                            )),
                        pressed ? _buildBody(context): SizedBox(),
                      ],
                    )),
              )
            ],
          ),
        ),
      );
    }

  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 20),child:Text("Loading..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }


  FutureBuilder<LoginResponse> _buildBody(BuildContext context) {
    LoginRequestBody requestBody = LoginRequestBody(email: "testbody", password: "testbody");

    final client = ApiClient(
        Dio(
            BaseOptions
              (
            contentType: "application/json",
            headers: {
            'Authorization': 'Basic ZGlzYXBpdXNlcjpkaXMjMTIz',
            'X-ApiKey': 'ZGslzIzEyMw==',
            'Content-Type': 'application/json'
            }
        )
        )
    );
    return FutureBuilder<LoginResponse>(
      future: client.login(requestBody),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {

          final LoginResponse posts = snapshot.data!;
          return Center(
            child: Text(
              posts.message.toString(),
              textAlign: TextAlign.center,
              textScaleFactor: 1.3,
            ),
          );
        }

        else {
          return Center(
            child:showLoaderDialog(context),
          );
        }
      },
    );
  }


  FutureBuilder<LoginResponse> _loginRequest(BuildContext context) {
    LoginRequestBody requestBody = LoginRequestBody(email: "testbody", password: "testbody");
    //  createUser(userInfo: requestBody);

    final client = ApiClient(Dio());
    return FutureBuilder<LoginResponse>(
        future: client.login(requestBody),
        builder: (context, snapshot) {
       print("snapping data $snapshot");
       return const Center(
         child: CircularProgressIndicator(
           color: Colors.blue,
         ),
       );
/*
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (_) {
                return Dialog(
                  // The background color
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        // The loading indicator
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 15,
                        ),
                        // Some text
                        Text('Loading...')
                      ],
                    ),
                  ),
                );
              });

          if (snapshot.connectionState == ConnectionState.done) {
            final LoginResponse? loginData = snapshot.data;
            return Center(
              child: Text(
                loginData!.message.toString(),
                textAlign: TextAlign.center,
                textScaleFactor: 1.3,
              ),
            );
          } else {
            print("snapshot: $snapshot.connectionState");
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          }*/
        });
  }

  Future<LoginResponse?> createUser(
      {required LoginRequestBody userInfo}) async {
    LoginResponse? retrievedUser;
    final Dio _dio = Dio();
    final _baseUrl = 'https://reqres.in/api';

    try {
      Response response = await _dio.post(
        _baseUrl + '/users',
        data: userInfo.toJson(),
      );

      print('User created: ${response.data}');

      retrievedUser = LoginResponse.fromJson(response.data);
    } catch (e) {
      print('Error creating user: $e');
    }

    return retrievedUser;
  }
}

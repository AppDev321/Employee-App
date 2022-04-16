import 'package:flutter/material.dart';
import 'package:hnh_flutter/custom_style/strings.dart';
import 'package:hnh_flutter/repository/model/request/login_data.dart';
import 'package:hnh_flutter/repository/model/response/login_response.dart';
import 'package:hnh_flutter/repository/retrofit/api_client.dart';
import 'package:dio/dio.dart';

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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      appName,
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      loginText,
                      style: TextStyle(fontSize: 20),
                    )),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'User Name',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    //forgot password screen
                  },
                  child: const Text(
                    forgotText,
                  ),
                ),
                Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: ElevatedButton(
                      child: const Text(loginText),
                      onPressed: () {
                        print(nameController.text);
                        print(passwordController.text);
                      },
                    )),
                Row(
                  children: <Widget>[
                    const Text('Does not have account?'),
                    TextButton(
                      child: const Text(
                        signUpText,
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        //signup screen
                        _loginRequest(context);



                      },
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        appVersion,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 10),
                      ),
                    )
                  ],
                ))
              ],
            )));
  }

  FutureBuilder<LoginResponse> _loginRequest(BuildContext context) {
    LoginRequestBody requestBody = new LoginRequestBody(email: "testbody", password: "testbody");
  //  createUser(userInfo: requestBody);


    final client = ApiClient(Dio());
    return FutureBuilder<LoginResponse>(
        future: client.login(requestBody),
        builder: (context, snapshot) {
          showDialog(
            // The user CANNOT close this dialog  by pressing outsite it
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
          print("snapshot: $snapshot.connectionState");
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
           return Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          }
        });
  }



  Future<LoginResponse?> createUser({required LoginRequestBody userInfo}) async {
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

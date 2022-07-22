import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hnh_flutter/custom_style/colors.dart';
import 'package:hnh_flutter/pages/shift/shift_list.dart';
import 'package:hnh_flutter/repository/model/request/login_data.dart';
import 'package:hnh_flutter/utils/controller.dart';

import '../../custom_style/dialog_builder.dart';
import '../../custom_style/progress_hud.dart';
import '../../view_models/login_view_model.dart';
import '../vehicle/vehicle_list.dart';

class LoginClass extends StatefulWidget {
  const LoginClass({Key? key}) : super(key: key);

  @override
  State<LoginClass> createState() => LoginClassStateful();
}

class LoginClassStateful extends State<LoginClass> {


  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final String _ambulaceSVG = "assets/images/img_ambulance_login.svg";
  DialogBuilder? _progressDialog;

  static const String _loginText = 'Login';

 final bool _isApiCallProcess = false;
  bool _passRemember= false;
  bool _isApiError=false;
  String _errorMsg= "";


   LoginViewModel _loginViewModel= LoginViewModel();



  @override
  void initState() {
    super.initState();
    _progressDialog =  DialogBuilder(context);
    _progressDialog?.initiateLDialog('Please wait..');

    _loginViewModel.addListener(() {
      if(_loginViewModel.getResponseStatus()) {
        var checkErrorApiStatus = _loginViewModel.getIsErrorRecevied();
        if(checkErrorApiStatus){
          setState(() {
            _isApiError = checkErrorApiStatus;
            _errorMsg =_loginViewModel.getErrorMsg();
          });
        }
        else
        {
          var auth = _loginViewModel.getUserToken();
          saveUserToken(auth);
          setState(() {
            _isApiError = checkErrorApiStatus;
            _errorMsg = "";

          });
        }
        _progressDialog?.hideOpenDialog();
        _loginViewModel.setResponseStatus(false);
      }

    });
  }


  @override
  Widget build(BuildContext context) {

    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: _isApiCallProcess,
      opacity: 0.3,
    );
  }

  Widget _uiSetup(BuildContext context) {
    return Container(
      decoration:const BoxDecoration(color: whiteColor),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
                alignment: Alignment.topCenter,
                padding:const EdgeInsets.only(left: 35, top: 130),
                child: SvgPicture.asset(_ambulaceSVG)),
            SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.5,
                      right: 35,
                      left: 35),
                  child: Column(
                    children: [
                    const  Text(
                        'Login to start your session',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style:  TextStyle(color: primaryTextColor,fontSize: 14,fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _emailController,
                        decoration:  InputDecoration(
                            filled: true,
                            fillColor: textFielBoxFillColor,
                            hintText: 'Email',
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: textFielBoxBorderColor, width: 1.0)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: textFielBoxBorderColor,
                                      width: 1.0))),
                        ),
                      const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor:textFielBoxFillColor,
                              hintText: 'Password',
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: textFielBoxBorderColor, width: 1.0)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const  BorderSide(
                                      color: textFielBoxBorderColor,
                                      width: 1.0))),
                        ),
                      const SizedBox(
                          height: 10,
                        ),
                        Container(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: ElevatedButton(
                              child: const Text(_loginText),
                            onPressed: () {
                              if(_emailController.text.isEmpty)
                                {
                                  setState(() {
                                    _isApiError = true;
                                    _errorMsg ="Please enter email";
                                  });
                                }else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(_emailController.text)) {
                                setState(() {
                                  _isApiError = true;
                                  _errorMsg ="Enter valid Email address";
                                });
                              }
                              else if(_passwordController.text.isEmpty)
                                {
                                  setState(() {
                                    _isApiError = true;
                                    _errorMsg ="Please enter password";
                                  });
                                }
                              else {
                                setState(() {
                                  _isApiError = false;
                                  _errorMsg ="";
                                });
                                _onLoginButtonPress(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                minimumSize:const Size(300, 50),
                                primary: Colors.black54,
                                padding:const EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32.0)),
                                textStyle:const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal)),
                          )),
                     // _pressed ? _buildBody(context) : SizedBox(),
                      _isApiError?  Text("$_errorMsg" , style: TextStyle(fontSize: 16,color: Colors.red),):const SizedBox(),
                      CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: const Text('Remember Me'),
                        value: _passRemember,
                        onChanged: (value) {
                          setState(() {
                            _passRemember = value!;
                          });
                        },
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  void _onLoginButtonPress(BuildContext context) async {
    _progressDialog?.showLoadingDialog();
    LoginRequestBody
    _requestBody = LoginRequestBody( email: _emailController.text, password: _passwordController.text);
   // LoginRequestBody(email: "mohsin121@afj.com", password: "123456");
    _loginViewModel.getUserLogin(_requestBody);
  }

  saveUserToken(String? token) async {
    Controller controller = Controller();
    await controller.setAuthToken(token!);
    await  controller.setRememberLogin(_passRemember);
    //Move to next location



    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => ShiftList(),
      ),
          (route) =>
      false, //if you want to disable back feature set to false
    );

  }




}

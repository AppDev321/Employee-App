import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hnh_flutter/custom_style/colors.dart';
import 'package:hnh_flutter/pages/shift/shift_list.dart';
import 'package:hnh_flutter/repository/model/request/login_data.dart';
import 'package:hnh_flutter/utils/controller.dart';
import 'package:hnh_flutter/widget/custom_text_widget.dart';
import 'package:hnh_flutter/widget/error_message.dart';

import '../../widget/dialog_builder.dart';
import '../../custom_style/progress_hud.dart';
import '../../view_models/login_view_model.dart';
import '../../widget/custom_edit_text_widget.dart';
import '../dashboard/dashboard.dart';

class LoginClass extends StatefulWidget {
  const LoginClass({Key? key}) : super(key: key);

  @override
  State<LoginClass> createState() => LoginClassStateful();
}

class LoginClassStateful extends State<LoginClass> {
  /* final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();*/
  final String _ambulaceSVG = "assets/images/afj_logo.png";
  DialogBuilder? _progressDialog;

  static const String _loginText = 'Login';
  final bool _isApiCallProcess = false;
  bool _passRemember = false;
  bool _isApiError = false;
  String _errorMsg = "";
  BuildContext? _dialogContext;

  LoginViewModel _loginViewModel = LoginViewModel();

  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _loginViewModel.addListener(() {
      _progressDialog?.hideOpenDialog();
      if (_loginViewModel.getResponseStatus()) {
        var checkErrorApiStatus = _loginViewModel.getIsErrorRecevied();
        if (checkErrorApiStatus) {
          setState(() {
            _isApiError = checkErrorApiStatus;
            _errorMsg = _loginViewModel.getErrorMsg();
          });
        } else {
          var auth = _loginViewModel.getUserToken();
          saveUserToken(auth);
          setState(() {
            _isApiError = checkErrorApiStatus;
            _errorMsg = "";
          });
        }

        _loginViewModel.setResponseStatus(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _dialogContext = context;
    if (_progressDialog == null) {
      _progressDialog = DialogBuilder(_dialogContext!);
      _progressDialog?.initiateLDialog('Please wait..');
    }

    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: _isApiCallProcess,
      opacity: 0.3,
    );
  }

  Widget _uiSetup(BuildContext context) {
    var colorText = !Get.isDarkMode?blackThemeTextColor:cardDarkThemeBg;

    Widget welcomeBack = Text(
      'Welcome Back',
      style: TextStyle(
          color: colorText,
          fontSize: 34.0,
          fontWeight: FontWeight.bold,
          shadows: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.15),
              offset: Offset(0, 5),
              blurRadius: 10.0,
            )
          ]),
    );

    Widget subTitle = Padding(
        padding: const EdgeInsets.only(right: 56.0),
        child: Text(
          'Login to your account',
          style: TextStyle(
            color:colorText,
            fontSize: 16.0,
          ),
        ));

    return Container(

      child: Scaffold(
        resizeToAvoidBottomInset: false,

        body: SingleChildScrollView(
          child: Container(
            height: Get.mediaQuery.size.height,
            child: Stack(
              fit: StackFit.expand,
              children: [

                !Get.isDarkMode? Container(color: cardThemeBaseColor)
                    :  Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              "https://img.freepik.com/free-photo/gray-abstract-wireframe-technology-background_53876-101941.jpg?w=2000",
                            )))),
                SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(
                        top: Get.mediaQuery.size.width / 2,
                        left: 25,
                        right: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        welcomeBack,

                        const SizedBox(
                          height: 50,
                        ),
                        subTitle,

                        const SizedBox(
                          height: 20,
                        ),
                        CustomEditTextWidget(
                          text: "Email",
                          controller: _emailController,
                        ),
                        const SizedBox(height: 20),
                        CustomEditTextWidget(
                            text: "Password",
                            controller: _passwordController,
                            isPasswordField: true),
                        CheckboxListTile(
                          checkColor: Colors.white,
                          activeColor:primaryColor,
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text('Remember Me'),
                          value: _passRemember,
                          onChanged: (value) {
                            setState(() {
                              _passRemember = value!;
                            });
                          },
                        ),

                        // _pressed ? _buildBody(context) : SizedBox(),
                        _isApiError
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ErrorMessageWidget(
                                  label: _errorMsg,
                                  color: Colors.redAccent,
                                ),
                              )
                            : const SizedBox(),

                        Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            child: ElevatedButton(
                              child: const Text(_loginText),
                              onPressed: () {
                                if (_emailController.text.isEmpty) {
                                  setState(() {
                                    _isApiError = true;
                                    _errorMsg = "Please enter email";
                                  });
                                } else if (!RegExp(r'\S+@\S+\.\S+')
                                    .hasMatch(_emailController.text)) {
                                  setState(() {
                                    _isApiError = true;
                                    _errorMsg = "Enter valid Email address";
                                  });
                                } else if (_passwordController.text.isEmpty) {
                                  setState(() {
                                    _isApiError = true;
                                    _errorMsg = "Please enter password";
                                  });
                                } else {
                                  setState(() {
                                    _isApiError = false;
                                    _errorMsg = "";
                                  });

                                  FocusScope.of(context).requestFocus(
                                      new FocusNode()); //remove focus
                                  _onLoginButtonPress(context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(300, 50),
                                  primary: primaryColor,
                                  padding: const EdgeInsets.all(10),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          Controller.roundCorner)),
                                  textStyle: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal)),
                            )),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onLoginButtonPress(BuildContext context) async {
    _progressDialog?.showLoadingDialog();
    LoginRequestBody _requestBody = LoginRequestBody(
        email: _emailController.text, password: _passwordController.text);
    // LoginRequestBody(email: "mohsin121@afj.com", password: "123456");
    _loginViewModel.getUserLogin(_requestBody);
  }

  saveUserToken(String? token) async {
    Controller controller = Controller();
    await controller.setAuthToken(token!);
    await controller.setRememberLogin(_passRemember);
    //Move to next location

    Get.offAll(() => Dashboard());
  }
}

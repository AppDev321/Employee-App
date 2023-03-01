import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hnh_flutter/pages/forgot_password/verify_email_code.dart';
import 'package:hnh_flutter/repository/model/request/forgot_password_request.dart';
import 'package:hnh_flutter/widget/custom_edit_text_widget.dart';
import 'package:hnh_flutter/widget/custom_text_widget.dart';

import '../../custom_style/colors.dart';
import '../../utils/controller.dart';
import '../../view_models/login_view_model.dart';
import '../../widget/dialog_builder.dart';
import '../../widget/error_message.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  final LoginViewModel _loginViewModel = LoginViewModel();
  bool _isApiError = false;
  String _errorMsg = "";
  DialogBuilder? _progressDialog;
  BuildContext? _dialogContext;

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
          // var auth = _loginViewModel.getForgotPasswordToken();
          // if (auth.isNotEmpty) {
          //   print(auth);
          //      saveUserToken(auth);
          // }
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

    var colorText = Get.isDarkMode ? blackThemeTextColor : cardDarkThemeBg;
    Widget forgotPassword = Text(
      'Forgot Password',
      style: TextStyle(
          color: colorText,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          shadows: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.15),
              offset: Offset(0, 5),
              blurRadius: 10.0,
            )
          ]),
    );

    return Scaffold(
      //appBar: AppBar(),
      body: SingleChildScrollView(
        child: SizedBox(
          height: Get.mediaQuery.size.height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Get.isDarkMode
                  ? Container(color: cardThemeBaseColor)
                  : Container(
                      decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/login_bg.jpg"),
                        fit: BoxFit.fitHeight,
                        alignment: Alignment.topCenter,
                      ),
                    )),
              Container(
                margin: EdgeInsets.only(
                    top: Get.mediaQuery.size.width / 3, left: 25, right: 25),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      forgotPassword,
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 150,
                        child: Image.asset('assets/images/afj_logo.png'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomTextWidget(
                        textAlign: TextAlign.center,
                        text:
                            "Enter the email address assosiated with your account.",
                        size: 20,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CustomTextWidget(
                        textAlign: TextAlign.center,
                        text:
                            "We will email you a link to reset your password.",
                        size: 16,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: CustomEditTextWidget(
                          isEmailField: true,
                          text: "Enter email address",
                          controller: emailController,
                        ),
                      ),
                      const SizedBox(height: 10),
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
                            onPressed: () async {
                              if (emailController.text.isEmpty) {
                                setState(() {
                                  _isApiError = true;
                                  _errorMsg = "Please enter valid Email";
                                });
                              } else {
                                setState(() {
                                  _isApiError = false;
                                  _errorMsg = "";
                                });
                                FocusScope.of(context).requestFocus(
                                     FocusNode()); //remove focus
                                _onForgotPasswordButtonPress(
                                    emailController.text);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(200, 50),
                                primary: primaryColor,
                                padding: const EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40)),
                                textStyle: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal)),
                            child: Text("Send"),
                          )),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onForgotPasswordButtonPress(String email) async {
    if(email.isNotEmpty)
      {
    _progressDialog?.showLoadingDialog();

    ForgotPasswordRequest forgotPasswordRequest =
        ForgotPasswordRequest(email: emailController.text);
    _loginViewModel.getUserForgotPassword(
      forgotPasswordRequest,
      (value) {
        if(value) {
          Get.to(() =>
              VerifyForgotPassword(
                email: emailController.text.toString(),
              ));
        }
      },
    );
  }
    else
      {
        Controller().showToastMessage(context,"Please enter valid email address");
      }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:hnh_flutter/pages/forgot_password/reset_password.dart';

import '../../custom_style/colors.dart';
import '../../repository/model/request/verify_email_code_request.dart';
import '../../view_models/login_view_model.dart';
import '../../widget/custom_text_widget.dart';
import '../../widget/dialog_builder.dart';
import '../../widget/error_message.dart';

class VerifyForgotPassword extends StatefulWidget {
  String? email;
   VerifyForgotPassword({Key? key,required this.email}) : super(key: key);

  @override
  State<VerifyForgotPassword> createState() => _VerifyForgotPasswordState();
}

class _VerifyForgotPasswordState extends State<VerifyForgotPassword> {
  final LoginViewModel _loginViewModel = LoginViewModel();
  bool _isApiError = false;
  String _errorMsg = "";
  DialogBuilder? _progressDialog;
  String verificationCode = '';

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
          var auth = _loginViewModel.getForgotPasswordToken();
          if (auth.isNotEmpty) {
            print(auth);
            //   saveUserToken(auth);
          }
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
    var colorText = Get.isDarkMode ? blackThemeTextColor : cardDarkThemeBg;
    Widget verifyCode = Text(
      'Verification',
      style: TextStyle(
          color: colorText,
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          shadows: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.15),
              offset: Offset(0, 5),
              blurRadius: 10.0,
            )
          ]),
    );

    return WillPopScope(
      onWillPop: () async => false,

      child: Scaffold(
        //  appBar: AppBar(),
        body: SingleChildScrollView(
          child: Container(
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
                        verifyCode,
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          height: 200,
                          child: Image.asset('assets/images/afj_logo.png'),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const CustomTextWidget(
                          textAlign: TextAlign.center,
                          text:
                              "Enter the verification code we just sent you on your email address.",
                          size: 20,
                        ),
                        const SizedBox(height: 30),
                        OtpTextField(
                          numberOfFields: 5,
                          borderColor: Colors.black,
                          //set to true to show as box or false to show as dash
                          showFieldAsBox: true,
                          //runs when a code is typed in
                          onCodeChanged: (String code) {
                            if (code.isEmpty) {
                              setState(() {
                                _isApiError = true;
                                _errorMsg = "Please enter code";
                              });
                            } else {
                              setState(() {
                                _isApiError = false;
                                _errorMsg = "";
                              });
                            }
                          },
                          onSubmit: (String verificationCode) {
                            VerifyEmailCodeRequest forgotPasswordRequest =
                                VerifyEmailCodeRequest(
                                    email: widget.email,
                                    token: verificationCode);
                            _loginViewModel.getEmailCode(
                              forgotPasswordRequest,
                              (value) {
                                Get.to(() => ResetPasswordScreen(email: widget.email.toString(),token: verificationCode,));
                              },
                            );
                          }, // end onSubmit
                        ),
                        _isApiError
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ErrorMessageWidget(
                                  label: _errorMsg,
                                  color: Colors.redAccent,
                                ),
                              )
                            : const SizedBox(),
                        const SizedBox(height: 30),
                        // Container(
                        //     alignment: Alignment.center,
                        //     padding: const EdgeInsets.all(10),
                        //     child: ElevatedButton(
                        //       onPressed: () async {

                        //       },
                        //       style: ElevatedButton.styleFrom(
                        //           minimumSize: const Size(200, 50),
                        //           primary: primaryColor,
                        //           padding: const EdgeInsets.all(10),
                        //           shape: RoundedRectangleBorder(
                        //               borderRadius: BorderRadius.circular(40)),
                        //           textStyle: const TextStyle(
                        //               fontSize: 20,
                        //               fontWeight: FontWeight.normal)),
                        //       child: Text("Verify"),
                        //     )),
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
}




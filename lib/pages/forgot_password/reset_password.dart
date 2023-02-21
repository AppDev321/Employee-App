import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hnh_flutter/pages/login/login.dart';
import 'package:hnh_flutter/repository/model/request/reset_password_request.dart';

import '../../custom_style/colors.dart';
import '../../custom_style/progress_hud.dart';
import '../../utils/controller.dart';
import '../../view_models/login_view_model.dart';
import '../../widget/custom_edit_text_widget.dart';
import '../../widget/custom_text_widget.dart';
import '../../widget/dialog_builder.dart';
import '../../widget/error_message.dart';

class ResetPasswordScreen extends StatefulWidget {
  String? email;
  String? token;
   ResetPasswordScreen({Key? key,required this.email,required this.token}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  DialogBuilder? _progressDialog;
  final bool _isApiCallProcess = false;
  bool _isApiError = false;
  String _errorMsg = "";
  BuildContext? _dialogContext;
  final LoginViewModel _loginViewModel = LoginViewModel();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController verifyPasswordController = TextEditingController();


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
          //    saveUserToken(auth);
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

    return ProgressHUD(
      inAsyncCall: _isApiCallProcess,
      opacity: 0.3,
      child: _uiSetup(context),
    );
  }

  Widget _uiSetup(BuildContext context) {
    var colorText = Get.isDarkMode ? blackThemeTextColor : cardDarkThemeBg;

    Widget welcomeBack = Text(
      'Reset Password',
      style: TextStyle(
          color: colorText,
          fontSize: 34.0,
          fontWeight: FontWeight.bold,
          shadows: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.15),
              offset: Offset(0, 5),
              blurRadius: 10.0,
            )
          ]),
    );


    return  WillPopScope(
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
                        welcomeBack,
                        SizedBox(
                          height: 30,
                        ),
                         CustomTextWidget(
                          textAlign: TextAlign.center,
                          text:
                          "Your new password must be different from other used passwords.",
                          size: 18,
                          color: Colors.grey.shade800,

                        ),
                        const SizedBox(height: 30),
                        CustomEditTextWidget(
                          text: "New Password",
                          controller: passwordController,
                        ),
                        const SizedBox(height: 20),
                        CustomEditTextWidget(
                            text: "Confirm Password",
                            controller: verifyPasswordController),
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
                              onPressed: () async{
                                if (passwordController.text.isEmpty) {
                                  setState(() {
                                    _isApiError = true;
                                    _errorMsg = "Please enter password";
                                  });
                                }
                                else if (verifyPasswordController.text.isEmpty) {
                                  setState(() {
                                    _isApiError = true;
                                    _errorMsg = "Please enter verify password";
                                  });
                                }
                                else if (passwordController.text != verifyPasswordController.text) {
                                  setState(() {
                                    _isApiError = true;
                                    _errorMsg = "Password mismatched";
                                  });
                                }

                                else {
                                  setState(() {
                                    _isApiError = false;
                                    _errorMsg = "";
                                  });
                                  FocusScope.of(context)
                                      .requestFocus( FocusNode()); //remove focus
                                  _onResetButtonPress(widget.email!,widget.token!,passwordController.text.toString());
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
                                      fontSize: 20, fontWeight: FontWeight.normal)),
                              child: const Text("Reset"),
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


  void _onResetButtonPress(String email, String token,String password)  {
    _progressDialog?.showLoadingDialog();

    ResetPasswordRequest requestBody =
    ResetPasswordRequest(email: email, token: token,password: password);
    _loginViewModel.resetUserPassword(requestBody ,(value) {
      Controller().setBiometericStatus(false);
      Get.off(() => const LoginClass());
    },);
  }
}

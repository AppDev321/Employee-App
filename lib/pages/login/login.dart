import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hnh_flutter/custom_style/colors.dart';
import 'package:hnh_flutter/repository/model/request/login_data.dart';
import 'package:hnh_flutter/utils/controller.dart';
import 'package:hnh_flutter/widget/error_message.dart';

import '../../custom_style/progress_hud.dart';
import '../../view_models/login_view_model.dart';
import '../../widget/custom_edit_text_widget.dart';
import '../../widget/dialog_builder.dart';
import '../dashboard/dashboard.dart';

class LoginClass extends StatefulWidget {
  const LoginClass({Key? key}) : super(key: key);

  @override
  State<LoginClass> createState() => LoginClassStateful();
}

class LoginClassStateful extends State<LoginClass> {
  /* final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();*/
  DialogBuilder? _progressDialog;

  static const String _loginText = 'Login';
  final bool _isApiCallProcess = false;
  bool _passRemember = false;
  bool _isApiError = false;
  String _errorMsg = "";
  BuildContext? _dialogContext;

  final LoginViewModel _loginViewModel = LoginViewModel();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  // final isAvailable =  Controller.hasBiometrics();
  var isBiometericEnable = false;

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
          if (auth.isNotEmpty) {
            saveUserToken(auth);
          }
          setState(() {
            _isApiError = checkErrorApiStatus;
            _errorMsg = "";
          });
        }

        _loginViewModel.setResponseStatus(false);
      }
    });

    _loginViewModel.getFinerPrintStatus().then((value) {
      setState(() {
        isBiometericEnable = value;
      });

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
      'Welcome Back',
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

    Widget subTitle = Padding(
        padding: const EdgeInsets.only(right: 56.0),
        child: Text(
          'Login to your account',
          style: TextStyle(
            color: colorText,
            fontSize: 16.0,
          ),
        ));

    return Scaffold(
      // resizeToAvoidBottomInset: false,

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
                      activeColor: primaryColor,
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

                              FocusScope.of(context)
                                  .requestFocus(new FocusNode()); //remove focus
                              _onLoginButtonPress(_emailController.text,
                                  _passwordController.text);
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
                          child: const Text(_loginText),
                        )),
                    const SizedBox(height: 10),
                    isBiometericEnable == true
                        ? Center(
                            child: IconButton(
                              onPressed: () {
                                _loginViewModel
                                    .authenticateWithBiometrics()
                                    .then((value) {
                                  if (value) _onFingerPrintCalled();
                                });
                              },
                              icon: const Icon(
                                Icons.fingerprint,
                                size: 60,
                              ),
                            ),
                          )
                        : const Center()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onLoginButtonPress(String email, String pass) async {
    _progressDialog?.showLoadingDialog();

    LoginRequestBody requestBody =
        LoginRequestBody(email: email, password: pass);
    // LoginRequestBody(email: "mohsin121@afj.com", password: "123456");
    _loginViewModel.getUserLogin(requestBody);
  }

  Future<void> _onFingerPrintCalled() async {
    var getEmailPref = await Controller().getEmail();
    var getPassPref = await Controller().getPassword();

    ///Decrypt
    ///
    ///
    ///


    if (getEmailPref != null || getPassPref != null) {
      _onLoginButtonPress(getEmailPref, getPassPref);
    }
  }

  saveUserToken(String? token) async {
    Controller controller = Controller();
    await controller.setRememberLogin(_passRemember);

    //Move to next location
    Get.offAll(() => const Dashboard());
  }

  Widget buildText(String text, bool checked) => Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            checked
                ? const Icon(Icons.check, color: Colors.green, size: 24)
                : const Icon(Icons.close, color: Colors.red, size: 24),
            const SizedBox(width: 12),
            Text(text, style: const TextStyle(fontSize: 24)),
          ],
        ),
      );
}

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hnh_flutter/repository/model/request/login_data.dart';
import 'package:hnh_flutter/webservices/APIWebServices.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:open_settings/open_settings.dart';
import '../utils/controller.dart';
import 'base_view_model.dart';

class LoginViewModel extends BaseViewModel {
  final LocalAuthentication localAuthentication = LocalAuthentication();
  var _auth = LocalAuthentication();
  String authToken = "";

  String getUserToken() => authToken;

  setUserAuth(String token) async {
    authToken = token;
  }

  Future<List<BiometricType>> getBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      return <BiometricType>[];
    }
  }

  Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      return false;
    }
  }

  Future<bool> authenticateIsAvailable() async {
    final isAvailable = await localAuthentication.canCheckBiometrics;
    final isDeviceSupported = await localAuthentication.isDeviceSupported();

    return isAvailable;
  }

  Future<bool> authenticateWithBiometrics() async {
    bool isAuthenticated = false;
    final isAvailable = await localAuthentication.canCheckBiometrics;
    final isDeviceSupported = await localAuthentication.isDeviceSupported();

      try {
        if(isAvailable && isDeviceSupported)
        isAuthenticated = await localAuthentication.authenticate(
          localizedReason: 'Please complete the biometrics to proceed.',
          options:
          AuthenticationOptions(useErrorDialogs: true, stickyAuth: true,),
        );
        else {
          OpenSettings.openBiometricEnrollSetting();
        }
      } on PlatformException catch (e) {
        if (e.code == auth_error.notEnrolled) {
          // Add handling of no hardware here.
        } else if (e.code == auth_error.lockedOut ||
            e.code == auth_error.permanentlyLockedOut) {
          // ...print("authenticate");
        }
      }
    return isAuthenticated;
  }


  Future<bool> getFinerPrintStatus() async {
    return  await Controller().getBiometericStatus();
  }

  Future<void> getUserLogin(LoginRequestBody body) async {
    setLoading(true);

    final results = await APIWebService().getLoginAuth(body);

    if (results == null) {
      var errorString = "Check your internet connection";
      setErrorMsg(errorString);
      setIsErrorReceived(true);
    } else {
      if (results.code == 200) {
        setUserAuth(results.data!.token!);

        //Save user login details
        if(results.data!.token!.isNotEmpty) {
          Controller().setAuthToken(results.data!.token!);
          Codec<String, String> stringToBase64 = utf8.fuse(base64);
          String encyptedEmail = stringToBase64.encode(body.email.toString());
          String encyptedPassword = stringToBase64.encode(body.password.toString());

          Controller().setEmail( encyptedEmail);
          Controller().setPassword( encyptedPassword);
        }
        setIsErrorReceived(false);
      } else {
        var errorString = "";
        for (int i = 0; i < results.errors!.length; i++) {
          errorString += "${results.errors![i].message!}\n";
        }
        setErrorMsg(errorString);
        setIsErrorReceived(true);
      }
    }
    setResponseStatus(true);
    setLoading(false);
    notifyListeners();
  }
}


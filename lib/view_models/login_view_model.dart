import 'package:flutter/services.dart';
import 'package:hnh_flutter/repository/model/request/login_data.dart';
import 'package:hnh_flutter/webservices/APIWebServices.dart';
import 'package:local_auth/local_auth.dart';

import '../utils/controller.dart';
import 'base_view_model.dart';

class LoginViewModel extends BaseViewModel {

  var _auth = LocalAuthentication();
  String authToken = "";

  String getUserToken() => authToken;

  bool biometericStatus = false;

  bool getBiometericStatus() => biometericStatus;

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

  Future<bool> authenticateWithBiometrics() async {

    final LocalAuthentication localAuthentication = LocalAuthentication();
    bool isBiometricSupported = await localAuthentication.isDeviceSupported();
    bool canCheckBiometrics = await localAuthentication.canCheckBiometrics;

    bool isAuthenticated = false;

    if (isBiometricSupported && canCheckBiometrics) {

      isAuthenticated = await localAuthentication.authenticate(
        localizedReason: 'Please complete the biometrics to proceed.',
        options:
        AuthenticationOptions(useErrorDialogs: true, stickyAuth: true),
      );

    }

    return isAuthenticated;
  }

  Future<void> getFinerPrintStatus() async {
    biometericStatus = await Controller().getBiometericStatus();
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
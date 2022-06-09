import 'package:flutter/material.dart';
import 'package:hnh_flutter/repository/model/request/login_data.dart';
import 'package:hnh_flutter/webservices/APIWebServices.dart';

import 'base_view_model.dart';

class LoginViewModel extends BaseViewModel {


  String authToken = "";
  String getUserToken() => authToken;

  setUserAuth(String token) async {
    authToken = token;
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
          errorString += results.errors![i].message! + "\n";
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

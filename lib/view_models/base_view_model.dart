import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class BaseViewModel extends ChangeNotifier
{


  bool isLoading = false;
  bool getLoading() => isLoading;

  bool isErrorReceived = false;
  bool getIsErrorRecevied() => isErrorReceived;

  bool isResponseRecived = false;
  bool getResponseStatus() => isResponseRecived;

  String errorMsg = "";
  String getErrorMsg() => errorMsg;

  setResponseStatus(bool loading) async {
    isResponseRecived = loading;
    // notifyListeners(); //only single time required
  }

  setErrorMsg(String error) async {
    errorMsg = error;

  }

  setLoading(bool loading) async {
    isLoading = loading;
    // notifyListeners(); //only single time required
  }

  setIsErrorReceived(bool loading) async {
    isErrorReceived = loading;
  }

}
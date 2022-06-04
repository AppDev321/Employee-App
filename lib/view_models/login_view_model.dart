import 'package:flutter/material.dart';
import 'package:hnh_flutter/repository/model/request/login_data.dart';
import 'package:hnh_flutter/webservices/APIWebServices.dart';

class LoginViewModel extends ChangeNotifier {
  bool isLoading = false;

  bool getLoading() => isLoading;
  String authToken = "";

  String getUserToken() => authToken;

  bool isResponseRecived = false;
  bool getResponseStatus() => isResponseRecived;


  setResponseStatus(bool loading) async {
    isResponseRecived = loading;
    // notifyListeners(); //only single time required
  }
  setLoading(bool loading) async {
    isLoading = loading;
   // notifyListeners(); //only single time required
  }

  setUserAuth(String token) async {
    authToken = token;
  }

 Future<void>getUserLogin(LoginRequestBody body) async {
    setLoading(true);
    final results = await APIWebService().getLoginAuth(body);
    //this.movies = results.map((item) => MovieViewModel(movie: item)).toList();
    setResponseStatus(true);
    setUserAuth(results);
    setLoading(false);
     notifyListeners();
  }
}

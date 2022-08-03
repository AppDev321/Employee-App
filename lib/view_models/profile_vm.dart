import 'package:flutter/material.dart';
import 'package:hnh_flutter/pages/shift/claimed_shift_list.dart';
import 'package:hnh_flutter/repository/model/request/change_password_request.dart';
import 'package:hnh_flutter/repository/model/request/claim_shift_request.dart';
import 'package:hnh_flutter/repository/model/request/leave_save_request.dart';
import 'package:hnh_flutter/repository/model/response/get_shift_list.dart';
import 'package:hnh_flutter/repository/model/response/vehicle_list_response.dart';
import 'package:hnh_flutter/view_models/base_view_model.dart';
import 'package:hnh_flutter/webservices/APIWebServices.dart';
import 'package:intl/intl.dart';

import '../repository/model/request/claim_shift_history_request.dart';
import '../repository/model/response/claimed_shift_list.dart';
import '../repository/model/response/leave_list.dart';
import '../repository/model/response/user_profile.dart';

class ProfileViewModel extends BaseViewModel {

   Profile profileDetail = Profile();
  setUserProfile(Profile data)
  {
    profileDetail = data;
  }
  getUserProfile() => profileDetail;

   bool isProfileUpdate = false;
   bool getProileUpdateStatus() => isProfileUpdate;

   setProfileStatus(bool error) async {
     isProfileUpdate = error;

   }



  Future<void> changePasswordRequest(ChangePasswordRequest request) async {
    setLoading(true);
    final results = await APIWebService().changePasswordRequest(request);

    if (results == null) {
      var errorString = "Check your internet connection";
      setErrorMsg(errorString);
      setIsErrorReceived(true);
    } else {
      if (results.code == 200) {

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



  Future<void> getProfileDetail() async {
    setLoading(true);
    final results = await APIWebService().getUserProfileDetails();

    if (results == null) {
      var errorString = "Check your internet connection";
      setErrorMsg(errorString);
      setIsErrorReceived(true);
    } else {
      if (results.code == 200) {
        setUserProfile(results.data!.profile!);
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


  Future<void> updateUserProfile(Profile request) async {
    setLoading(true);
    final results = await APIWebService().updateUserProfileDetail(request);

    if (results == null) {
      setProfileStatus(false);
      var errorString = "Check your internet connection";
      setErrorMsg(errorString);
   //   setIsErrorReceived(true);
    } else {
      if (results.code == 200) {
        setProfileStatus(true);
      //  setIsErrorReceived(false);
      } else {
        var errorString = "";
        for (int i = 0; i < results.errors!.length; i++) {
          errorString += results.errors![i].message! + "\n";
        }
        setErrorMsg(errorString);
       // setIsErrorReceived(true);
        setProfileStatus(false);
      }
    }

    setResponseStatus(true);
    setLoading(false);
    notifyListeners();
  }


}

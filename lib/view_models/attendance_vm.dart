import 'package:flutter/material.dart';
import 'package:hnh_flutter/pages/shift/claimed_shift_list.dart';
import 'package:hnh_flutter/repository/model/request/availability_request.dart';
import 'package:hnh_flutter/repository/model/request/claim_shift_request.dart';
import 'package:hnh_flutter/repository/model/request/leave_save_request.dart';
import 'package:hnh_flutter/repository/model/request/overtime_save_request.dart';
import 'package:hnh_flutter/repository/model/response/get_shift_list.dart';
import 'package:hnh_flutter/repository/model/response/vehicle_list_response.dart';
import 'package:hnh_flutter/view_models/base_view_model.dart';
import 'package:hnh_flutter/webservices/APIWebServices.dart';
import 'package:intl/intl.dart';

import '../repository/model/request/claim_shift_history_request.dart';
import '../repository/model/response/claimed_shift_list.dart';
import '../repository/model/response/leave_list.dart';
import '../repository/model/response/overtime_list.dart';

class AttendanceViewModel extends BaseViewModel {


  bool requestStatus=false;
  bool getRequestStatus() => requestStatus;

  setAttendanceRequestStatus(bool error) async {
    requestStatus = error;

  }


  Future<void> markAttendanceRequest(String code,int attendanceType) async {
    setLoading(true);
    //0- check in , 1- check out
    final results = attendanceType == 0 ?await APIWebService().markAttendance(code) : await APIWebService().markClockOutAttendance(code);

    if (results == null) {
      var errorString = "Check your internet connection";
      setErrorMsg(errorString);
      setAttendanceRequestStatus(false);
     // setIsErrorReceived(true);
    } else {
      if (results.code == 200) {
        setAttendanceRequestStatus(true);
       // setIsErrorReceived(false);
      } else {
        var errorString = "";
        for (int i = 0; i < results.errors!.length; i++) {
          errorString += results.errors![i].message! + "\n";
        }
        setErrorMsg(errorString);
        setAttendanceRequestStatus(false);
      //  setIsErrorReceived(true);
      }
    }

    setResponseStatus(true);
    setLoading(false);
    notifyListeners();
  }



  Future<void> verifyVehicleTab(String code) async {
    setLoading(true);
    final results = await APIWebService().validateVehicleTab(code);

    if (results == null) {
      var errorString = "Check your internet connection";
      setErrorMsg(errorString);
      setAttendanceRequestStatus(false);
      // setIsErrorReceived(true);
    } else {
      if (results.code == 200) {
        setAttendanceRequestStatus(true);
        // setIsErrorReceived(false);
      } else {
        var errorString = "";
        for (int i = 0; i < results.errors!.length; i++) {
          errorString += results.errors![i].message! + "\n";
        }
        setErrorMsg(errorString);
        setAttendanceRequestStatus(false);
        //  setIsErrorReceived(true);
      }
    }

    setResponseStatus(true);
    setLoading(false);
    notifyListeners();
  }



}

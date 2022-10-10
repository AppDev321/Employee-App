import 'package:flutter/material.dart';
import 'package:hnh_flutter/pages/shift/claimed_shift_list.dart';
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

class OvertimeViewModel extends BaseViewModel {


  List<OvertimeHistory> overtimeList = [];
  List<OvertimeHistory> getOvertimeHistoryList() => overtimeList;
  setOvertimeHistoryList(List<OvertimeHistory> data)
  {
    overtimeList = data;
  }



  bool overTimePosted=false;
  bool getOverTimeStatus() => overTimePosted;

  setOverTimeStatus(bool error) async {
    overTimePosted = error;

  }



  Future<void> getOverTimeList(ClaimShiftHistoryRequest request) async {
    setLoading(true);
    final results = await APIWebService().getOvertimeListHistory(request);

    if (results == null) {
      var errorString = "Check your internet connection";
      setErrorMsg(errorString);

       setIsErrorReceived(true);
    } else {
      if (results.code == 200) {

        setOvertimeHistoryList(results.data!.overtimeHistory!);

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




  Future<void> saveOverTimeRequest(OvertimeRequest request) async {
    setLoading(true);
    final results = await APIWebService().saveOvertimeRequest(request);

    if (results == null) {
      var errorString = "Check your internet connection";
      setErrorMsg(errorString);
      setOverTimeStatus(false);
     // setIsErrorReceived(true);
    } else {
      if (results.code == 200) {
        setOverTimeStatus(true);
       // setIsErrorReceived(false);
      } else {
        var errorString = "";
        for (int i = 0; i < results.errors!.length; i++) {
          errorString += "${results.errors![i].message!}\n";
        }
        setErrorMsg(errorString);
        setOverTimeStatus(false);
      //  setIsErrorReceived(true);
      }
    }

    setResponseStatus(true);
    setLoading(false);
    notifyListeners();
  }


  Future<void> deleteOverTimeRequest(String requestCode) async {
    setLoading(true);
    final results = await APIWebService().deleteOverTimeRequest(requestCode);

    if (results == null) {
      var errorString = "Check your internet connection";
      setErrorMsg(errorString);

      // setIsErrorReceived(true);
    } else {
      if (results.code == 200) {
        setOverTimeStatus(true);

      } else {
        var errorString = "";
        for (int i = 0; i < results.errors!.length; i++) {
          errorString += "${results.errors![i].message!}\n";
        }
        setErrorMsg(errorString);

        //  setIsErrorReceived(true);
      }
    }

    setResponseStatus(true);
    setLoading(false);
    notifyListeners();
  }



}

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

class AvailabilityViewModel extends BaseViewModel {

  List<AvailabilityRequest>? availabilities;
  bool requestStatus=false;
  bool getRequestStatus() => requestStatus;

  setAvailabilityRequestStatus(bool error) async {
    requestStatus = error;

  }


  Future<void> saveAvailabilityRequest(AvailabilityRequest request) async {
    setLoading(true);
    final results = await APIWebService().saveAvailabilityRequest(request);

    if (results == null) {
      var errorString = "Check your internet connection";
      setErrorMsg(errorString);
      setAvailabilityRequestStatus(false);
     // setIsErrorReceived(true);
    } else {
      if (results.code == 200) {
        setAvailabilityRequestStatus(true);
       // setIsErrorReceived(false);
      } else {
        var errorString = "";
        for (int i = 0; i < results.errors!.length; i++) {
          errorString += results.errors![i].message! + "\n";
        }
        setErrorMsg(errorString);
        setAvailabilityRequestStatus(false);
      //  setIsErrorReceived(true);
      }
    }

    setResponseStatus(true);
    setLoading(false);
    notifyListeners();
  }



  Future<void> getAvailabilityList(ClaimShiftHistoryRequest request) async {
    setLoading(true);
    setAvailabilityRequestStatus(false);
    final results = await APIWebService().getAvailabilityList(request);

    if (results == null) {
      var errorString = "Check your internet connection";
      setErrorMsg(errorString);

    setIsErrorReceived(true);
    } else {

      if (results.code == 200) {
        setIsErrorReceived(false);
        if(results.data!.availabilities!.length > 0)
        {
          availabilities = results.data!.availabilities!;
        }
        else
        {
          setIsErrorReceived(true);
          availabilities=[];
          setErrorMsg("No Data found");
        }

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


  Future<void> deleteAvailabilityRequest(String requestCode) async {
    setLoading(true);
    final results = await APIWebService().deleteAvailabilityRequest(requestCode);

    if (results == null) {
      var errorString = "Check your internet connection";
      setErrorMsg(errorString);
      setAvailabilityRequestStatus(false);
      // setIsErrorReceived(true);
    } else {
      if (results.code == 200) {
        setAvailabilityRequestStatus(true);
        // setIsErrorReceived(false);
      } else {
        var errorString = "";
        for (int i = 0; i < results.errors!.length; i++) {
          errorString += "${results.errors![i].message!}\n";
        }
        setErrorMsg(errorString);
        setAvailabilityRequestStatus(false);
        //  setIsErrorReceived(true);
      }
    }

    setResponseStatus(true);
    setLoading(false);
    notifyListeners();
  }





}

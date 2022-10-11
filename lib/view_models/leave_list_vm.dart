import 'package:flutter/material.dart';
import 'package:hnh_flutter/pages/shift/claimed_shift_list.dart';
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

class LeaveListViewModel extends BaseViewModel {




  List<Leaves> _LeaveList = [];
  List<DropMenuItems> _LeaveTypes = [];





  List<Leaves> getLeaveList() {
    return _LeaveList;
  }

  setLeaveList(List<Leaves> data) async {
    _LeaveList = data;
  }


  List<DropMenuItems> getLeaveTypes() {
    return _LeaveTypes;
  }

  setLeaveTypes(List<DropMenuItems> data) async {
    _LeaveTypes = data;
  }



  bool claimError=false;
  bool getClaimError() => claimError;

  setClaimError(bool error) async {
    claimError = error;

  }


  Future<void> getLeaveHistoryList(ClaimShiftHistoryRequest weeklyShiftDate) async {
    setLoading(true);
    final results = await APIWebService().getLeaveListHistory(weeklyShiftDate);

    if (results == null) {
      var errorString = "Check your internet connection";
      setErrorMsg(errorString);
      setIsErrorReceived(true);
    } else {
      if (results.code == 200) {
        setLeaveList(results.data!.leaves!);
        setLeaveTypes(results.data!.leaveTypes!);
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





  Future<void> saveLeaveRequest(LeaveRequest request) async {
    setLoading(true);
    final results = await APIWebService().saveLeaveRequest(request);

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



  Future<void> deleteOverTimeRequest(String requestCode) async {
    setLoading(true);
    final results = await APIWebService().deleteOverTimeRequest(requestCode);

    if (results == null) {
      var errorString = "Check your internet connection";
      setErrorMsg(errorString);

      // setIsErrorReceived(true);
    } else {
      if (results.code == 200) {


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
    //notifyListeners();
  }



}

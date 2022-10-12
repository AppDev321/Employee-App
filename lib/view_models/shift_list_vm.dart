import 'package:flutter/material.dart';
import 'package:hnh_flutter/pages/shift/claimed_shift_list.dart';
import 'package:hnh_flutter/repository/model/request/claim_shift_request.dart';
import 'package:hnh_flutter/repository/model/response/get_shift_list.dart';
import 'package:hnh_flutter/repository/model/response/vehicle_list_response.dart';
import 'package:hnh_flutter/view_models/base_view_model.dart';
import 'package:hnh_flutter/webservices/APIWebServices.dart';
import 'package:intl/intl.dart';

import '../repository/model/request/claim_shift_history_request.dart';
import '../repository/model/response/claimed_shift_list.dart';

class ShiftListViewModel extends BaseViewModel {
  ShiftListViewModel() {

  }

  List<Shifts> _shiftsList = [];
  List<Shifts> _openShiftList = [];
  List<Claims> _claimedHisotryList = [];


  bool _claimResponseSuccess = false;

  bool get claimResponseSuccess => _claimResponseSuccess;


   setClaimResponse(bool value)  {
    _claimResponseSuccess = value;
  }


  List<Claims> getClaimedHistoryShiftList() {
    return _claimedHisotryList;
  }

  setClaimedHisotryList(List<Claims> data) async {
    _claimedHisotryList = data;
  }

  List<Shifts> getMyShiftList() {
    return _shiftsList;
  }

  setShiftList(List<Shifts> data) async {
    _shiftsList = data;
  }

  List<Shifts> getOpenShiftList() {
    return _openShiftList;
  }

  setOpenShiftList(List<Shifts> data) async {
    _openShiftList = data;
  }

  bool claimError=false;
  bool getClaimError() => claimError;

  setClaimError(bool error) async {
    claimError = error;

  }


  Future<void> getShiftList(String weeklyShiftDate) async {
    setLoading(true);
    final results = await APIWebService().getShiftList(weeklyShiftDate);

    if (results == null) {
      var errorString = "Check your internet connection";
      setErrorMsg(errorString);
      setIsErrorReceived(true);
    } else {
      if (results.code == 200) {
        setOpenShiftList(results.data!.openShifts!);
        setShiftList(results.data!.shifts!);
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



  Future<void> claimOpenShift(ClaimShiftRequest request) async {
    setLoading(true);
    final results = await APIWebService().getClaimOpenShift(request);

    if (results == null) {
      var errorString = "Check your internet connection";
      setErrorMsg(errorString);
      setClaimError(true);
    } else {
      if (results.code == 200) {
        setClaimResponse(true);

      } else {
        var errorString = "";
        for (int i = 0; i < results.errors!.length; i++) {
          errorString += results.errors![i].message! + "\n";
        }
        setErrorMsg(errorString);
       // setIsErrorReceived(true);
        setClaimError(true);
      }
    }

    setResponseStatus(true);
    setLoading(false);
    notifyListeners();
    setIsErrorReceived(false);
  }



  Future<void> getClaimedShiftHistoryList(ClaimShiftHistoryRequest weeklyShiftDate) async {
    setLoading(true);
    final results = await APIWebService().getClaimHistoryShift(weeklyShiftDate);

    if (results == null) {
      var errorString = "Check your internet connection";
      setErrorMsg(errorString);
      setIsErrorReceived(true);
    } else {
      if (results.code == 200) {
        setIsErrorReceived(false);
        if(results.data!.claims!.length >0)
          {
            setClaimedHisotryList(results.data!.claims!);
          }
        else
          {
            setIsErrorReceived(true);
            setErrorMsg("No Shift found");
            setClaimedHisotryList([]);
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





}

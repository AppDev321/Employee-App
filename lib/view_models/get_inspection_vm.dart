import 'package:hnh_flutter/repository/model/request/inspection_check_request.dart';
import 'package:hnh_flutter/view_models/base_view_model.dart';
import 'package:hnh_flutter/webservices/APIWebServices.dart';

import '../repository/model/request/save_inspection_request.dart';
import '../repository/model/response/get_inspection_check_api_response.dart';

class GetInspectionCheckViewModel extends BaseViewModel {
  late Vehicle _vehicleData;

  late Inspection _inspectionData;
  late Check _checkDetail;
  late List<CheckOptions> _radioOptions;
   bool _isInspectionCompleted = false;
  int _totalCheckCount = 0;
  late Solved? _solvedAnwser;



  Solved? getAlreadySolvedComments() {
    return _solvedAnwser;
  }

  setSolvedComment(Solved? data) async {
    _solvedAnwser = data;
  }



  int getTotalCheckCount() {
    return _totalCheckCount;
  }

  setTotalCheckCount(int data) async {
    _totalCheckCount = data;
  }

  Vehicle getVehicleData() {
    return _vehicleData;
  }

  setVehicleData(Vehicle data) async {
    _vehicleData = data;
  }

  Inspection getInspectionData() {
    return _inspectionData;
  }

  setInspectionData(Inspection data) async {
    _inspectionData = data;
  }

  Check getCheckData() {
    return _checkDetail;
  }

  setCheckData(Check data) async {
    _checkDetail = data;
  }

  List<CheckOptions> getRadioOptions() {
    return _radioOptions;
  }

  setRadioOptions(List<CheckOptions> data) async {
    _radioOptions = data;
  }



  bool getInspectionCompleted() {
    return _isInspectionCompleted;
  }

  setInspectionCompleted(bool data) async {
    _isInspectionCompleted = data;
  }




  Future<void> getInspectionCheck(CheckInspectionRequest body) async {
    setLoading(true);
    final results = await APIWebService().getInspectionCheck(body);
    if (results == null) {
      var errorString = "Check your internet connection";
      setErrorMsg(errorString);
      setIsErrorReceived(true);
    } else {
      if (results.code == 200) {
        //Vehicle info result
        setVehicleData(results.data!.vehicle!);
        setInspectionData(results.data!.inspection!);
        setCheckData(results.data!.check!);
        setRadioOptions(results.data!.options!);
        setTotalCheckCount(results.data!.totalCount!);
       setSolvedComment(results.data!.check!.solved);


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

  Future<void> saveInspectionCheck(SaveInspectionCheckRequest body) async {
    setLoading(true);
    final results = await APIWebService().saveInspection(body);
    if (results == null) {
      var errorString = "Check your internet connection";
      setErrorMsg(errorString);
      setIsErrorReceived(true);
    } else {
      if (results.code == 200) {
        setInspectionCompleted(results.data!.completed!);
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

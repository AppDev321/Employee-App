import 'package:hnh_flutter/repository/model/request/claim_shift_request.dart';
import 'package:hnh_flutter/repository/model/request/save_inspection_request.dart';
import 'package:hnh_flutter/repository/model/response/get_shift_list.dart';
import 'package:hnh_flutter/repository/model/response/login_api_response.dart';
import 'package:hnh_flutter/repository/model/response/save_inspection_check_api_response.dart';
import 'package:hnh_flutter/repository/model/response/vehicle_get_inspection_resposne.dart';
import 'package:hnh_flutter/repository/model/response/vehicle_list_response.dart';

import '../repository/model/request/create_inspection_request.dart';
import '../repository/model/request/inspection_check_request.dart';
import '../repository/model/request/login_data.dart';
import '../repository/model/request/save_inspection_post_data.dart';
import '../repository/model/request/vechicle_get_inspection_request.dart';
import '../repository/model/response/create_inspection_api_response.dart';
import '../repository/model/response/get_inspection_check_api_response.dart';
import '../repository/retrofit/client_header.dart';

class APIWebService {

  static const String exceptionString="Exception";
  final String TAG="ExcAPI=>";

  Future<LoginApiResponse?> getLoginAuth(LoginRequestBody body) async {
    try {
      final client = await RetroClinetHeader.getClientWithoutAuth();
      var response = await client.login(body);
     return response;
    } catch (e) {
      print("$TAG$e");
      return null;
    }
  }

  Future<GetVehicleListResponse?> getVehicleList() async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.getVehiclesList();
      return response;
    } catch (e) {
      print("$TAG$e");
      return null;
    }
  }

  Future<VehicleGetInspectionResponse?> getVehicleInspectionData(VechicleInspectionRequest body) async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.getVehiclesInspectionList(body);
      return response;
    } catch (e) {
      print("$TAG$e");
      return null;
    }
  }
  Future<CreateInspectionResponse?> createVehicleInspection(CreateInspectionRequest body) async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.createVehicleInspection(body);
      return response;
    } catch (e) {
      print("$TAG$e");
      return null;
    }
  }

  Future<GetInspectionCheckResponse?> getInspectionCheck(CheckInspectionRequest body) async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.getInspectionCheck(body);
      return response;
    } catch (e) {
      print("$TAG$e");

      return null;
    }
  }


  Future<SaveInspectionCheckResponse?> saveInspection(PostInspectionData body) async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.saveInspectionCheck(body);
      return response;
    } catch (e) {
      print("$TAG$e");
      return null;
    }
  }



  Future<GetShiftListResponse?> getShiftList(String weeklyShiftDate) async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.getShiftDataList(weeklyShiftDate);
      return response;
    } catch (e) {
      print("$TAG$e");
      return null;
    }
  }
  Future<LoginApiResponse?> getClaimOpenShift(ClaimShiftRequest request) async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.claimOpenShift(request);
      return response;
    } catch (e) {
      print("$TAG$e");
      return null;
    }
  }

}

import 'package:hnh_flutter/repository/model/request/availability_request.dart';
import 'package:hnh_flutter/repository/model/request/change_password_request.dart';
import 'package:hnh_flutter/repository/model/request/claim_shift_request.dart';
import 'package:hnh_flutter/repository/model/request/leave_save_request.dart';
import 'package:hnh_flutter/repository/model/request/overtime_save_request.dart';
import 'package:hnh_flutter/repository/model/request/save_inspection_request.dart';
import 'package:hnh_flutter/repository/model/response/get_notification.dart';
import 'package:hnh_flutter/repository/model/response/get_shift_list.dart';
import 'package:hnh_flutter/repository/model/response/login_api_response.dart';
import 'package:hnh_flutter/repository/model/response/save_inspection_check_api_response.dart';
import 'package:hnh_flutter/repository/model/response/user_profile.dart';
import 'package:hnh_flutter/repository/model/response/vehicle_get_inspection_resposne.dart';
import 'package:hnh_flutter/repository/model/response/vehicle_list_response.dart';

import '../repository/model/request/claim_shift_history_request.dart';
import '../repository/model/request/create_inspection_request.dart';
import '../repository/model/request/inspection_check_request.dart';
import '../repository/model/request/login_data.dart';
import '../repository/model/request/save_inspection_post_data.dart';
import '../repository/model/request/vechicle_get_inspection_request.dart';
import '../repository/model/response/availability_list.dart';
import '../repository/model/response/claimed_shift_list.dart';
import '../repository/model/response/create_inspection_api_response.dart';
import '../repository/model/response/get_dashboard.dart';
import '../repository/model/response/get_inspection_check_api_response.dart';
import '../repository/model/response/leave_list.dart';
import '../repository/model/response/overtime_list.dart';
import '../repository/model/response/report_attendance_response.dart';
import '../repository/model/response/report_lateness_response.dart';
import '../repository/model/response/report_leave_response.dart';
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

  Future<ClaimShiftListResponse?> getClaimHistoryShift(ClaimShiftHistoryRequest request) async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.claimShiftHistory(request);
      return response;
    } catch (e) {
      print("$TAG$e");
      return null;
    }
  }


  Future<LeaveListResponse?> getLeaveListHistory(ClaimShiftHistoryRequest request) async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.leavesListHistory(request);
      return response;
    } catch (e) {
      print("$TAG$e");
      return null;
    }
  }


  Future<LoginApiResponse?> saveLeaveRequest(LeaveRequest request) async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.leaveRequest(request);
      return response;
    } catch (e) {
      print("$TAG$e");
      return null;
    }
  }

  Future<OvertimeListResponse?> getOvertimeListHistory(ClaimShiftHistoryRequest request) async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.getOvertimeHistory(request);
      return response;
    } catch (e) {
      print("$TAG$e");
      return null;
    }
  }




  Future<LoginApiResponse?> saveOvertimeRequest(OvertimeRequest request) async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.saveOvertimeRequest(request);
      return response;
    } catch (e) {
      print("$TAG$e");
      return null;
    }
  }

  Future<LoginApiResponse?> saveAvailabilityRequest(AvailabilityRequest request) async
  {

    try{
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.saveAvailabilityRequest(request);
      return response;
    }
        catch(e)
    {
      return null;
    }
  }


  Future<AvailabilityListResponse?> getAvailabilityList(ClaimShiftHistoryRequest request) async
  {

    try{
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.getAvailabilityList(request);
      return response;
    }
    catch(e)
    {
      return null;
    }
  }


  Future<LoginApiResponse?> deleteAvailabilityRequest(String code) async
  {

    try{
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.deleteAvailabilityRequest(code);
      return response;
    }
    catch(e)
    {
      return null;
    }
  }


  Future<LoginApiResponse?> changePasswordRequest(ChangePasswordRequest request) async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.changePassword(request);
      return response;
    } catch (e) {
      print("$TAG$e");
      return null;
    }
  }



  Future<UserProfileDetail?> getUserProfileDetails() async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.getProfileAccount();
      return response;
    } catch (e) {
      print("$TAG$e");
      return null;
    }
  }


  Future<LoginApiResponse?> updateUserProfileDetail(Profile request) async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.updateProfileAccount(request);
      return response;
    } catch (e) {
      print("$TAG$e");
      return null;
    }
  }

  Future<LeaveReportResponse?> getLeaveReport(ClaimShiftHistoryRequest request) async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.getLeaveReport(request);
      return response;
    } catch (e) {
      print("$TAG$e");
      return null;
    }
  }


  Future<LatenessReportResponse?> getLatenessReport(ClaimShiftHistoryRequest request) async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.getLatenessReport(request);
      return response;
    } catch (e) {
      print("$TAG$e");
      return null;
    }
  }



  Future<AttendanceReportResponse?> getAttendanceReport(ClaimShiftHistoryRequest request) async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.getAttandenceReport(request);
      return response;
    } catch (e) {
      print("$TAG$e");
      return null;
    }
  }
  Future<GetDashBoardResponse?> getDashBoardData() async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.getDashboardData();
      return response;
    } catch (e) {
      print("$TAG$e");
      return null;
    }
  }
  Future<GetNotificationResponse?> getNotification() async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.getNotificationList();
      return response;
    } catch (e) {
      print("$TAG$e");
      return null;
    }
  }

  Future<LoginApiResponse?> updateNotificationStatus(String id) async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.updateNotificationStatus(id);
      return response;
    } catch (e) {
      print("$TAG$e");
      return null;
    }
  }
  Future<LoginApiResponse?> deleteNotification(String id) async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.deleteNotification(id);
      return response;
    } catch (e) {
      print("$TAG$e");
      return null;
    }
  }


  Future<LoginApiResponse?> getNotificationCount() async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.getNotificationCount();
      return response;
    } catch (e) {
      print("$TAG$e");
      return null;
    }
  }



  Future<String?> postTokenToServer(Map<String,String> request) async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.postFcmToken(request);
      return response;
    } catch (e) {
      print("$TAG$e");
      return null;
    }
  }


}

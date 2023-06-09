import 'package:hnh_flutter/repository/model/request/availability_request.dart';
import 'package:hnh_flutter/repository/model/request/change_password_request.dart';
import 'package:hnh_flutter/repository/model/request/claim_shift_request.dart';
import 'package:hnh_flutter/repository/model/request/leave_save_request.dart';
import 'package:hnh_flutter/repository/model/request/overtime_save_request.dart';
import 'package:hnh_flutter/repository/model/response/app_version_reponse.dart';
import 'package:hnh_flutter/repository/model/response/events_list.dart';
import 'package:hnh_flutter/repository/model/response/get_notification.dart';
import 'package:hnh_flutter/repository/model/response/get_shift_list.dart';
import 'package:hnh_flutter/repository/model/response/login_api_response.dart';
import 'package:hnh_flutter/repository/model/response/user_profile.dart';

import '../repository/model/request/claim_shift_history_request.dart';
import '../repository/model/request/forgot_password_request.dart';
import '../repository/model/request/login_data.dart';
import '../repository/model/request/reset_password_request.dart';
import '../repository/model/request/verify_email_code_request.dart';
import '../repository/model/request/web_login_data.dart';
import '../repository/model/response/availability_list.dart';
import '../repository/model/response/claimed_shift_list.dart';
import '../repository/model/response/contact_list.dart';
import '../repository/model/response/get_dashboard.dart';
import '../repository/model/response/leave_list.dart';
import '../repository/model/response/overtime_list.dart';
import '../repository/model/response/report_attendance_response.dart';
import '../repository/model/response/report_lateness_response.dart';
import '../repository/model/response/report_leave_response.dart';
import '../repository/retrofit/client_header.dart';
import '../utils/controller.dart';

class APIWebService {

  static const String exceptionString="Exception";
  final String TAG="ExcAPI=>";

  Future<LoginApiResponse?> getLoginAuth(LoginRequestBody body) async {
    try {
      final client = await RetroClinetHeader.getClientWithoutAuth();
      var response = await client.login(body);
     return response;
    } catch (e) {
      Controller().printLogs("$TAG$e");
      return null;
    }
  }

  Future<LoginApiResponse?> getForgotPasswordData(ForgotPasswordRequest body) async {
    try {
      final client = await RetroClinetHeader.getClientWithoutAuth();
      var response = await client.forgotPassword(body);
      return response;
    } catch (e) {
      Controller().printLogs("$TAG$e");
      return null;
    }
  }

  Future<LoginApiResponse?> getEmailCodeData(VerifyEmailCodeRequest body) async {
    try {
      final client = await RetroClinetHeader.getClientWithoutAuth();
      var response = await client.verifyEmailCode(body);
      return response;
    } catch (e) {
      Controller().printLogs("$TAG$e");
      return null;
    }
  }


  Future<LoginApiResponse?> resetPasswordData(ResetPasswordRequest body) async {
    try {
      final client = await RetroClinetHeader.getClientWithoutAuth();
      var response = await client.resetPassword(body);
      return response;
    } catch (e) {
      Controller().printLogs("$TAG$e");
      return null;
    }
  }


  Future<GetShiftListResponse?> getShiftList(String weeklyShiftDate) async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.getShiftDataList(weeklyShiftDate);
      return response;
    } catch (e) {
      Controller().printLogs("$TAG$e");
      return null;
    }
  }
  Future<LoginApiResponse?> getClaimOpenShift(ClaimShiftRequest request) async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.claimOpenShift(request);
      return response;
    } catch (e) {
      Controller().printLogs("$TAG$e");
      return null;
    }
  }

  Future<ClaimShiftListResponse?> getClaimHistoryShift(ClaimShiftHistoryRequest request) async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.claimShiftHistory(request);
      return response;
    } catch (e) {
      Controller().printLogs("$TAG$e");
      return null;
    }
  }


  Future<LeaveListResponse?> getLeaveListHistory(ClaimShiftHistoryRequest request) async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.leavesListHistory(request);
      return response;
    } catch (e) {
      Controller().printLogs("$TAG$e");
      return null;
    }
  }


  Future<LoginApiResponse?> saveLeaveRequest(LeaveRequest request) async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.leaveRequest(request);
      return response;
    } catch (e) {
      Controller().printLogs("$TAG$e");
      return null;
    }
  }

  Future<OvertimeListResponse?> getOvertimeListHistory(ClaimShiftHistoryRequest request) async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.getOvertimeHistory(request);
      return response;
    } catch (e) {
      Controller().printLogs("$TAG$e");
      return null;
    }
  }


  Future<LoginApiResponse?> saveOvertimeRequest(OvertimeRequest request) async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.saveOvertimeRequest(request);
      return response;
    } catch (e) {
      Controller().printLogs("$TAG$e");
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


  Future<LoginApiResponse?> deleteLeaveRequest(String id) async
  {

    try{
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.deleteLeaveRequest(id);
      return response;
    }
    catch(e)
    {
      return null;
    }
  }



  Future<LoginApiResponse?> deleteOverTimeRequest(String id) async
  {

    try{
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.deleteOvertimeRequest(id);
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
      Controller().printLogs("$TAG$e");
      return null;
    }
  }



  Future<UserProfileDetail?> getUserProfileDetails() async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.getProfileAccount();
      return response;
    } catch (e) {
      Controller().printLogs("$TAG$e");
      return null;
    }
  }
  Future<AppVersionResponse?> getAppVersion() async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.getAppVersionCheck();
      return response;
    } catch (e) {
      Controller().printLogs("$TAG$e");
      return null;
    }
  }
  Future<EventListResponse?> getEventsList() async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.getEvents();
      return response;
    } catch (e) {
      Controller().printLogs("$TAG$e");
      return null;
    }
  }

  Future<LoginApiResponse?> updateUserProfileDetail(Profile request) async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.updateProfileAccount(request);
      return response;
    } catch (e) {
      Controller().printLogs("$TAG$e");
      return null;
    }
  }

  Future<LeaveReportResponse?> getLeaveReport(ClaimShiftHistoryRequest request) async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.getLeaveReport(request);
      return response;
    } catch (e) {
      Controller().printLogs("$TAG$e");
      return null;
    }
  }


  Future<LatenessReportResponse?> getLatenessReport(ClaimShiftHistoryRequest request) async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.getLatenessReport(request);
      return response;
    } catch (e) {
      Controller().printLogs("$TAG$e");
      return null;
    }
  }



  Future<AttendanceReportResponse?> getAttendanceReport(ClaimShiftHistoryRequest request) async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.getAttandenceReport(request);
      return response;
    } catch (e) {
      Controller().printLogs("$TAG$e");
      return null;
    }
  }
  Future<GetDashBoardResponse?> getDashBoardData() async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.getDashboardData();
      return response;
    } catch (e) {
      Controller().printLogs("$TAG$e");
      return null;
    }
  }
  Future<GetNotificationResponse?> getNotification() async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.getNotificationList();
      return response;
    } catch (e) {
      Controller().printLogs("$TAG$e");
      return null;
    }
  }

  Future<LoginApiResponse?> updateNotificationStatus(String id) async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.updateNotificationStatus(id);
      return response;
    } catch (e) {
      Controller().printLogs("$TAG$e");
      return null;
    }
  }
  Future<LoginApiResponse?> deleteNotification(String id) async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.deleteNotification(id);
      return response;
    } catch (e) {
      Controller().printLogs("$TAG$e");
      return null;
    }
  }
  Future<LoginApiResponse?> markAttendance(String code,String uploadID) async {
    try {
      Map<String,String> request = {
        'code': code,
        'upload_id':uploadID
      };
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.markAttendance(request);
      return response;
    } catch (e) {
      Controller().printLogs("$TAG$e");
      return null;
    }
  }

  Future<LoginApiResponse?> markClockOutAttendance(String code,String uploadID) async {
    try {
      Map<String,String> request = {
        'code': code,
        'upload_id':uploadID
      };
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.markClockOutAttendance(request);
      return response;
    } catch (e) {
      Controller().printLogs("$TAG$e");
      return null;
    }
  }

  Future<LoginApiResponse?> validateVehicleTab(String code,String uploadID) async {
    try {
      Map<String,String> request = {
        'code': code,
        'upload_id':uploadID
      };
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.validateVehicleTab(request);
      return response;
    } catch (e) {
      Controller().printLogs("$TAG$e");
      return null;
    }
  }


  Future<LoginApiResponse?> webLoginRequest(WebLoginRequest request) async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.webLoginRequest(request);
      return response;
    } catch (e) {
      Controller().printLogs("$TAG$e");
      return null;
    }
  }

  Future<LoginApiResponse?> getNotificationCount() async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.getNotificationCount();
      return response;
    } catch (e) {
      Controller().printLogs("$TAG$e");
      return null;
    }
  }
  Future<ContactListResponse?> getContactList() async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.getContactList();
      return response;
    } catch (e) {
      Controller().printLogs("$TAG$e");
      return null;
    }
  }


  Future<String?> postTokenToServer(Map<String,String> request) async {
    try {
      final client = await RetroClinetHeader.getClientWithAuth();
      var response = await client.postFcmToken(request);
      return response;
    } catch (e) {
      Controller().printLogs("$TAG$e");
      return null;
    }
  }


}

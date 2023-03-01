import 'package:dio/dio.dart';
import 'package:hnh_flutter/repository/model/request/availability_request.dart';
import 'package:hnh_flutter/repository/model/request/leave_save_request.dart';
import 'package:hnh_flutter/repository/model/request/login_data.dart';
import 'package:hnh_flutter/repository/model/request/overtime_save_request.dart';
import 'package:hnh_flutter/repository/model/response/app_version_reponse.dart';
import 'package:hnh_flutter/repository/model/response/availability_list.dart';
import 'package:hnh_flutter/repository/model/response/events_list.dart';
import 'package:hnh_flutter/repository/model/response/leave_list.dart';
import 'package:hnh_flutter/repository/model/response/user_profile.dart';
import 'package:hnh_flutter/repository/retrofit/logging.dart';
import 'package:retrofit/http.dart';
import '../../utils/controller.dart';
import '../model/request/change_password_request.dart';
import '../model/request/claim_shift_history_request.dart';
import '../model/request/claim_shift_request.dart';
import '../model/request/forgot_password_request.dart';
import '../model/request/reset_password_request.dart';
import '../model/request/verify_email_code_request.dart';
import '../model/request/web_login_data.dart';
import '../model/response/claimed_shift_list.dart';
import '../model/response/contact_list.dart';
import '../model/response/get_dashboard.dart';
import '../model/response/get_notification.dart';
import '../model/response/get_shift_list.dart';
import '../model/response/login_api_response.dart';
import '../model/response/overtime_list.dart';
import '../model/response/report_attendance_response.dart';
import '../model/response/report_lateness_response.dart';
import '../model/response/report_leave_response.dart';
part 'api_client.g.dart';


@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio) {

    return _ApiClient(dio);
  }
  @GET('/app-check')
  Future<AppVersionResponse> getAppVersionCheck();

  @POST('/login')
  Future<LoginApiResponse> login(@Body() LoginRequestBody body);

  @POST('/forgot-password')
  Future<LoginApiResponse> forgotPassword(@Body() ForgotPasswordRequest body);

  @POST('/verify-email')
  Future<LoginApiResponse> verifyEmailCode(@Body() VerifyEmailCodeRequest body);

  @POST('/reset-password')
  Future<LoginApiResponse> resetPassword(@Body() ResetPasswordRequest body);

  @POST('/logout')
  Future<void> logout();

  @GET('/my-shifts?date={date}')
  Future<GetShiftListResponse> getShiftDataList(@Path("date") String weeklyShiftDate);

  @POST('/claim-shift')
  Future<LoginApiResponse> claimOpenShift(@Body() ClaimShiftRequest body);

  @POST('/claim-history')
  Future<ClaimShiftListResponse> claimShiftHistory(@Body() ClaimShiftHistoryRequest body);

  @POST('/my-leaves')
  Future<LeaveListResponse> leavesListHistory(@Body() ClaimShiftHistoryRequest body);

  @POST('/leave-request')
  Future<LoginApiResponse> leaveRequest(@Body() LeaveRequest body);
  @POST('/leave-request/delete?leave_request_id={id}')
  Future<LoginApiResponse> deleteLeaveRequest(@Path("id") String id);

  @POST('/change-password')
  Future<LoginApiResponse> changePassword(@Body() ChangePasswordRequest body);

  @GET('/profile-details')
  Future<UserProfileDetail> getProfileAccount();

  @GET('/events')
  Future<EventListResponse> getEvents();

  @POST('/update-profile')
  Future<LoginApiResponse> updateProfileAccount(@Body() Profile body);

  @POST('/request-overtime')
  Future<LoginApiResponse> saveOvertimeRequest(@Body() OvertimeRequest body);

  @POST('/overtime-request/delete?overtime_request_id={id}')
  Future<LoginApiResponse> deleteOvertimeRequest(@Path("id") String id);

  @POST('/overtime-request-history')
  Future<OvertimeListResponse> getOvertimeHistory(@Body() ClaimShiftHistoryRequest body);

  @POST('/availability-request/store')
  Future<LoginApiResponse> saveAvailabilityRequest(@Body() AvailabilityRequest body);

  @POST('/availability-request/index')
  Future<AvailabilityListResponse> getAvailabilityList(@Body() ClaimShiftHistoryRequest body);

  @POST('/availability-request/delete?code={code}')
  Future<LoginApiResponse> deleteAvailabilityRequest(@Path("code") String code);


  @POST('/attendance/mark-clock-in')
  Future<LoginApiResponse> markAttendance(@Body() Map<String,String> body);
  @POST('/attendance/mark-clock-out')
  Future<LoginApiResponse> markClockOutAttendance(@Body() Map<String,String> body);

  @POST('/validate-qr-code')
  Future<LoginApiResponse> validateVehicleTab(@Body()  Map<String,String>  body );
  @POST('/qr-login')
  Future<LoginApiResponse> webLoginRequest(@Body() WebLoginRequest body);

  @POST('/report/leaves')
  Future<LeaveReportResponse> getLeaveReport(@Body() ClaimShiftHistoryRequest body);

  // @POST('/leave-request/delete')
  // Future<LeaveReportResponse> getLeaveReport(@Body() ClaimShiftHistoryRequest);
  //
  // @POST('/leave-request/delete')
  // Future<LeaveReportResponse> getLeaveReport(@Body() ClaimShiftHistoryRequest);

  @POST('/report/my-attendance')
  Future<AttendanceReportResponse> getAttandenceReport(@Body() ClaimShiftHistoryRequest body);

  @POST('/report/lateness')
  Future<LatenessReportResponse> getLatenessReport(@Body() ClaimShiftHistoryRequest body);

  @POST('/update-fcm-token')
  Future<String> postFcmToken(@Body() Map<String,String> body);

  @GET('/employee-dashboard')
  Future<GetDashBoardResponse> getDashboardData();

  @POST('/notification/my-notifications')
  Future<GetNotificationResponse> getNotificationList();

  @POST('/notification/delete-notification?notification_id={id}')
  Future<LoginApiResponse> deleteNotification(@Path("id") String notificaitonID);

  @POST('/notification/change-read-status?notification_id={id}')
  Future<LoginApiResponse> updateNotificationStatus(@Path("id") String notificaitonID);

  @GET('/notification/get-notification-count')
  Future<LoginApiResponse> getNotificationCount();

  @GET('/contact-list')
  Future<ContactListResponse> getContactList();

}

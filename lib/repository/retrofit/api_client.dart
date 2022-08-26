import 'package:dio/dio.dart';
import 'package:hnh_flutter/repository/model/request/availability_request.dart';
import 'package:hnh_flutter/repository/model/request/leave_save_request.dart';
import 'package:hnh_flutter/repository/model/request/login_data.dart';
import 'package:hnh_flutter/repository/model/request/overtime_save_request.dart';
import 'package:hnh_flutter/repository/model/response/availability_list.dart';
import 'package:hnh_flutter/repository/model/response/leave_list.dart';
import 'package:hnh_flutter/repository/model/response/user_profile.dart';

import 'package:hnh_flutter/repository/retrofit/logging.dart';

import 'package:retrofit/http.dart';

import '../model/request/change_password_request.dart';
import '../model/request/claim_shift_history_request.dart';
import '../model/request/claim_shift_request.dart';

import '../model/response/claimed_shift_list.dart';

import '../model/response/get_dashboard.dart';

import '../model/response/get_shift_list.dart';
import '../model/response/login_api_response.dart';
import '../model/response/overtime_list.dart';
import '../model/response/report_attendance_response.dart';
import '../model/response/report_lateness_response.dart';
import '../model/response/report_leave_response.dart';


part 'api_client.g.dart';

@RestApi(baseUrl: 'http://vmi808920.contaboserver.net/api') // Enter you base URL
//@RestApi(baseUrl: 'http://192.168.1.21:8000/api') // Enter you base URL

abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) {

    dio.interceptors.add(Logging());

    return _ApiClient(dio, baseUrl: baseUrl);
  }


  @POST('/login')
  Future<LoginApiResponse> login(@Body() LoginRequestBody body);

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

  @POST('/change-password')
  Future<LoginApiResponse> changePassword(@Body() ChangePasswordRequest body);

  @GET('/profile-details')
  Future<UserProfileDetail> getProfileAccount();

  @POST('/update-profile')
  Future<LoginApiResponse> updateProfileAccount(@Body() Profile body);

  @POST('/request-overtime')
  Future<LoginApiResponse> saveOvertimeRequest(@Body() OvertimeRequest body);

  @POST('/overtime-request-history')
  Future<OvertimeListResponse> getOvertimeHistory(@Body() ClaimShiftHistoryRequest body);

  @POST('/availability-request/store')
  Future<LoginApiResponse> saveAvailabilityRequest(@Body() AvailabilityRequest body);
  @POST('/availability-request/index')
  Future<AvailabilityListResponse> getAvailabilityList(@Body() ClaimShiftHistoryRequest body);
  @POST('/availability-request/delete?code={code}')
  Future<LoginApiResponse> deleteAvailabilityRequest(@Path("code") String code);



  @POST('/report/my-leaves')
  Future<LeaveReportResponse> getLeaveReport(@Body() ClaimShiftHistoryRequest body);
  @POST('/report/my-attendance')
  Future<AttendanceReportResponse> getAttandenceReport(@Body() ClaimShiftHistoryRequest body);
  @POST('/report/lateness')
  Future<LatenessReportResponse> getLatenessReport(@Body() ClaimShiftHistoryRequest body);

  @POST('/update-fcm-token')
  Future<String> postFcmToken(@Body() Map<String,String> body);


  @GET('/employee-dashboard')
  Future<GetDashBoardResponse> getDashboardData();


/*
  @GET(Api.users)
  Future<Res> getUsers();
  
   // ===== POST ===== //
  //   const key =
  //    'Bearer ff4fd8240cf758b51b2971c3d96556bba5f3b5838be52828a778f60246b4d935';
  @POST("users")
  @http.Headers(<String, dynamic>{
    HttpHeaders.authorizationHeader: key,
  })
  Future<GetUserResponse> createUser(@Body() User user);

  // ===== PUT / PATCH ===== //
  @PUT("users/{id}")
  @http.Headers(<String, dynamic>{
    HttpHeaders.authorizationHeader: key,
  })
  Future<GetUserResponse> updateUser(@Path() String id, @Body() User user);

  // ===== DELETE ===== //
  @DELETE('users/{id}')
  @http.Headers(<String, dynamic>{
    HttpHeaders.authorizationHeader: key,
  })
  Future<void> deleteUser(@Path("id") int id);
  */


}

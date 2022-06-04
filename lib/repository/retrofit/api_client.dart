import 'package:background_locator/location_dto.dart';
import 'package:dio/dio.dart';
import 'package:hnh_flutter/repository/model/request/login_data.dart';
import 'package:hnh_flutter/repository/model/response/vehicle_list_response.dart';
import 'package:hnh_flutter/repository/retrofit/logging.dart';

import 'package:retrofit/http.dart';

import '../model/request/vechicle_get_inspection_request.dart';
import '../model/response/login_api_response.dart';
import '../model/response/vehicle_get_inspection_resposne.dart';
part 'api_client.g.dart';

@RestApi(baseUrl: 'http://vmi808920.contaboserver.net/api/') // Enter you base URL

abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) {
   /* dio.options = BaseOptions(
        receiveTimeout: 30000,
        connectTimeout: 30000,
        contentType: 'application/json',
        *//* If needed headers *//*
        headers: {
          'Content-Type': 'application/json'
        });
 //   dio.interceptors.add(LogInterceptor()); //开启请求日志*/
dio.interceptors.add(Logging());
    return _ApiClient(dio, baseUrl: baseUrl);
  }


// Login service
  @POST('/login') // enter your api method
  Future<LoginApiResponse> login(@Body() LoginRequestBody body);

  @POST('/update-location') // enter your api method
  Future<void> updateLocation(@Body() LocationDto body);

  @POST('/logout') // enter your api method
  Future<void> logout();

  @GET('/vehicles')
  Future<GetVehicleListResponse> getVehiclesList();

  @POST('/vehicles/inspections')
  Future<VehicleGetInspectionResponse> getVehiclesInspectionList(@Body() VechicleInspectionRequest body);

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

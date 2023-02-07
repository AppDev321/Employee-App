import '../../utils/controller.dart';
import 'api_client.dart';
import 'package:dio/dio.dart';

import 'logging.dart';


class RetroClinetHeader
{


 static Future<ApiClient> getClientWithAuth() async{
    Controller controller = Controller();
    String? userToken = await controller.getAuthToken();
    var dio = Dio(BaseOptions(
      baseUrl: Controller.appBaseURL,
        connectTimeout:30000,
        contentType: "application/json", headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${userToken}',
      'Accept': 'application/json'
    }
    ));
    dio.interceptors.add(Logging());
    final client = ApiClient( dio);


    return client;
  }
 static ApiClient getClientWithoutAuth() {

   var dio = Dio(BaseOptions(
       baseUrl: Controller.appBaseURL,
       connectTimeout:30000,
       contentType: "application/json", headers: {
     'Content-Type': 'application/json',
     'Accept': 'application/json'
   }
   ));

   dio.interceptors.add(Logging());
   final client =  ApiClient(dio);



   return client;
 }

}
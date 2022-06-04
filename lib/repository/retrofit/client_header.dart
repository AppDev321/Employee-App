import '../../utils/controller.dart';
import 'api_client.dart';
import 'package:dio/dio.dart';


class RetroClinetHeader
{


 static Future<ApiClient> getClientWithAuth() async{
    Controller controller = Controller();
    String? userToken = await controller.getAuthToken();

    final client =
    ApiClient(Dio(BaseOptions(contentType: "application/json", headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${userToken}',
      'Accept': 'application/json'
    })));
    return client;
  }
 static ApiClient getClientWithoutAuth() {
   final client =
   ApiClient(Dio(BaseOptions(contentType: "application/json", headers: {
     'Content-Type': 'application/json',
     'Accept': 'application/json'
   })));
   return client;
 }

}
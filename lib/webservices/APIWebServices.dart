import 'package:hnh_flutter/repository/model/response/vehicle_get_inspection_resposne.dart';
import 'package:hnh_flutter/repository/model/response/vehicle_list_response.dart';

import '../repository/model/request/login_data.dart';
import '../repository/model/request/vechicle_get_inspection_request.dart';
import '../repository/retrofit/client_header.dart';

class APIWebService {

   static const String exceptionString="Exception";
   final String TAG="ExcAPI=>";
  Future<String> getLoginAuth(LoginRequestBody body) async {
    try {
      final client = await RetroClinetHeader.getClientWithoutAuth();
      var response = await client.login(body);
      return response.token!;
    } catch (e) {
      print("$TAG$e");
      return exceptionString;
    }
  }

   Future<List<Vehicles>> getVehicleList() async {
     try {
       final client = await RetroClinetHeader.getClientWithAuth();
       var response = await client.getVehiclesList();
       return response.vehicles!;
     } catch (e) {
       print("$TAG$e");
       return [];
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

}

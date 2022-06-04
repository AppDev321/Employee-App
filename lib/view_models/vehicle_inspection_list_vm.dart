import 'package:flutter/material.dart';
import 'package:hnh_flutter/repository/model/response/vehicle_list_response.dart';
import 'package:hnh_flutter/webservices/APIWebServices.dart';

import '../repository/model/request/vechicle_get_inspection_request.dart';
import '../repository/model/response/vehicle_get_inspection_resposne.dart';

class VehicleInspectionListViewModel extends ChangeNotifier {
  bool isLoading = true;

  bool getLoading() => isLoading;
  bool isResponseRecived = false;

  bool getResponseStatus() => isResponseRecived;
  bool isErrorApi = false;

  bool getErrorApi() => isErrorApi;



  bool hideCreateInspectionView = false;
  bool checkInspectionViewStatus() => hideCreateInspectionView;

  setInspectionViewStatus(bool show) async {
    hideCreateInspectionView = show;

  }

  setResponseStatus(bool loading) async {
    isResponseRecived = loading;

  }

  setLoading(bool loading) async {
    isLoading = loading;
  }

  setErrorApi(bool isError) async {
    isErrorApi = isError;
  }

  VehicleGetInspectionResponse? inspectionResponse;

  VehicleGetInspectionResponse? getInspectionResponse() => inspectionResponse;

  setInspectionResponse(VehicleGetInspectionResponse? data) {
    inspectionResponse = data;
  }

  /*VehicleInspectionListViewModel(VechicleInspectionRequest body) {
    getInspectionVehicles(body);
  }*/

  Future<void> getInspectionVehicles(VechicleInspectionRequest body) async {
    setLoading(true);
    final results = await APIWebService().getVehicleInspectionData(body);

    if (results != null) {
      setErrorApi(true);
    } else {
      setErrorApi(false);
    }

    setInspectionResponse(results);
    setLoading(false);
    setResponseStatus(true);
    notifyListeners();
  }

  List<Vehicles> makeListPagination(
      List<Vehicles> allItems, int page, int limit) {
    int totalItems = allItems.length;
    int fromIndex = page * limit;
    int toIndex = fromIndex + limit;
    if (fromIndex <= totalItems) {
      if (toIndex > totalItems) {
        toIndex = totalItems;
      }
      return allItems.sublist(0, toIndex);
    } else {
      return [];
    }
  }

  List<Vehicles> runSearchFilter(String enteredKeyword, List<Vehicles> list) {
    List<Vehicles> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = list;
    } else {
      results = list
          .where((vehicle) =>
              vehicle.vrn!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    return results;
  }
}

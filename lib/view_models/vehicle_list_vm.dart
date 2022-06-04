import 'package:flutter/material.dart';
import 'package:hnh_flutter/repository/model/response/vehicle_list_response.dart';
import 'package:hnh_flutter/webservices/APIWebServices.dart';

class VehicleListViewModel extends ChangeNotifier {
  bool isLoading = true;

  bool getLoading() => isLoading;

  bool isResponseRecived = false;

  bool getResponseStatus() => isResponseRecived;


  List<Vehicles> _listVehicles = [];

  List<Vehicles> getVehiclesList() {

   return _listVehicles;
  }

  bool isErrorApi = false;

  bool getErrorApi() => isErrorApi;
  VehicleListViewModel()
  {
    getVehicles();
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

  setVehicles(List<Vehicles> data) async {
    _listVehicles = data;

  }

  Future<void> getVehicles() async {
    setLoading(true);
    final results = await APIWebService().getVehicleList();

    if (results.isEmpty) {
      setErrorApi(true);
    } else {
      setErrorApi(false);
    }
    setVehicles(results);
    setLoading(false);

    setResponseStatus(true);
    notifyListeners();

  }

  List<Vehicles> makeListPagination(
      List<Vehicles> allItems, int page, int limit) {
    int totalItems = allItems.length;
    int fromIndex = page * limit;
    int toIndex = fromIndex + limit;

    print("from=${fromIndex} to=${toIndex}");
    if (fromIndex <= totalItems) {
      if (toIndex > totalItems) {
        toIndex = totalItems;
      }
      return allItems.sublist(0, toIndex);
    } else {
      return [];
    }
  }

  List<Vehicles> runSearchFilter(String enteredKeyword,List<Vehicles> list) {
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

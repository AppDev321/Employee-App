import 'package:flutter/material.dart';
import 'package:hnh_flutter/repository/model/response/vehicle_list_response.dart';
import 'package:hnh_flutter/view_models/base_view_model.dart';
import 'package:hnh_flutter/webservices/APIWebServices.dart';

import '../repository/model/request/create_inspection_request.dart';
import '../repository/model/request/vechicle_get_inspection_request.dart';
import '../repository/model/response/vehicle_get_inspection_resposne.dart';

class VehicleInspectionListViewModel extends BaseViewModel {



  bool hideCreateInspectionView = false;
  bool checkInspectionViewStatus() => hideCreateInspectionView;
  setInspectionViewStatus(bool show) async {
    hideCreateInspectionView = show;
  }

  VehicleGetInspectionResponse? inspectionResponse;
  VehicleGetInspectionResponse? getInspectionResponse() => inspectionResponse;

  setInspectionResponse(VehicleGetInspectionResponse? data) {
    inspectionResponse = data;
  }

  String vehicleName="";
  String getVehicleName() => vehicleName;

  List<Inspections> _vehicleInspectionList = [];
  List<Inspections> getVehicleInspectionList() =>_vehicleInspectionList;
  setVehicleInspectionList( List<Inspections> inspectionList)
  {
    _vehicleInspectionList = inspectionList;
  }

bool isInspectionCreated = false;
  bool checkIsInspectionCreated() => isInspectionCreated;
  setInspectionCreated(bool isCreated)
  {
    isInspectionCreated = isCreated;

  }



   setVehicleName(String name)
  {
    vehicleName=name;
  }

  Future<void> createVehicleInspection(CreateInspectionRequest body) async {

    setLoading(true);
    final results = await APIWebService().createVehicleInspection(body);
    if (results == null) {
      var errorString = "Check your internet connection";
      setErrorMsg(errorString);
      setIsErrorReceived(true);
    } else {
      if (results.code == 200) {
        setInspectionCreated(true);
        setIsErrorReceived(false);
      } else
      {
        var errorString = "";
        for (int i = 0; i < results.errors!.length; i++)
        {
          errorString += results.errors![i].message! + "\n";
        }
        setErrorMsg(errorString);
        setIsErrorReceived(true);
      }
    }
    setResponseStatus(true);
    setLoading(false);
    notifyListeners();

  }

  Future<void> getInspectionVehicles(VechicleInspectionRequest body) async {

    setLoading(true);
    final results = await APIWebService().getVehicleInspectionData(body);

    if (results == null) {
      var errorString = "Check your internet connection";
      setErrorMsg(errorString);
      setIsErrorReceived(true);
    } else {
      if (results.code == 200) {
        setVehicleInspectionList(results.data!.vehicle!.inspections!);
        setVehicleName("Inspection | ${results.data!.vehicle!.vrn} (${results.data!.vehicle!.make} ${results.data!.vehicle!.type})");

        setIsErrorReceived(false);
      } else
      {
        var errorString = "";
        for (int i = 0; i < results.errors!.length; i++)
        {
          errorString += results.errors![i].message! + "\n";
          }

        setErrorMsg(errorString);
        setIsErrorReceived(true);
      }
    }

    setResponseStatus(true);
    setLoading(false);
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

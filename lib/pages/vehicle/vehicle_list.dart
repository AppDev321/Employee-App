import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hnh_flutter/custom_style/strings.dart';
import 'package:hnh_flutter/pages/vehicleInspection/vehicle_inspection_list.dart';
import 'package:hnh_flutter/repository/model/response/vehicle_list_response.dart';
import 'package:hnh_flutter/view_models/vehicle_list_vm.dart';
import 'package:hnh_flutter/widget/navigation_drawer_new.dart';

import '../../custom_style/text_style.dart';
import '../../main.dart';
import '../../notification/firebase_notification.dart';
import '../login/login.dart';

class VehicleList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return VehicleListState();
  }
}

class VehicleListState extends State<VehicleList> {
  int _page = 0;
  int _limit = 20;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  bool _isErrorInApi = false;
  String? _errorMsg= "";
  List<Vehicles> _vehicleList = [];
  List<Vehicles> _vehicleListComplete = [];
  List<Vehicles> _vehiclePaginatedList = [];
  late BuildContext contextBuild;
  late ScrollController _controller;
  late VehicleListViewModel _vehicleListViewModel;
  TextEditingController _searchController = new TextEditingController();

  void getData() async {
    setState(() {
      _isFirstLoadRunning = _vehicleListViewModel.getLoading();
      _isErrorInApi = _vehicleListViewModel.getIsErrorRecevied();
    });
    if (_vehicleListComplete.length > 0) {
      _setPaginationList();
    }
  }
  void _setPaginationList() {
    var list = _vehicleListViewModel.makeListPagination(
        _vehicleListComplete, _page, _limit);
    if (list.length > 0) {
      _vehiclePaginatedList=list;
      _vehicleList = list;

    } else {
      setState(() {
        _hasNextPage = false;
      });
    }
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 500) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _page += 1;

     await Future.delayed(Duration(seconds: 1), (){
        _setPaginationList();
        setState(() {
          _isLoadMoreRunning = false;
        });
      });


    }
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      _isFirstLoadRunning = true;
      _isErrorInApi = false;
    });

    _vehicleListViewModel = VehicleListViewModel();
    _vehicleListViewModel.addListener(() {
      _vehicleListComplete.clear();
        var checkErrorApiStatus = _vehicleListViewModel.getIsErrorRecevied();
        if(checkErrorApiStatus){
          setState(() {
            _isErrorInApi = checkErrorApiStatus;
          _errorMsg = _vehicleListViewModel.getErrorMsg();
          if (_errorMsg!.contains(ConstantData.unauthenticatedMsg)) {
            Navigator.pushAndRemoveUntil<dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => LoginClass(),
              ),
              (route) =>
                  false, //if you want to disable back feature set to false
            );
          }
        });
        }
        else
        {
           _vehicleListComplete =_vehicleListViewModel.getVehiclesList();
          setState(() {
            _isErrorInApi = checkErrorApiStatus;
            _errorMsg = "";
          });
        }


      getData();


    });


    _controller =  ScrollController()..addListener(_loadMore);
  }





  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    contextBuild = context;



    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Inspection'),
      ),
      drawer: NavigationDrawer(),
      body: _isErrorInApi
          ? Center(
              child: Text(
              '$_errorMsg',
              textAlign: TextAlign.center,
              textScaleFactor: 1.3,
              style: errorTextStyle,
            ))
          : _isFirstLoadRunning
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20, bottom: 10, left: 10, right: 10),
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Color(0xFFe9eaec),
                            borderRadius: BorderRadius.circular(15)),
                        child: TextField(
                          onChanged: (value) => {
                            setState(() {
                              _vehicleList = _vehicleListViewModel.runSearchFilter(value, _vehiclePaginatedList);
                            })
                          },
                          cursorColor: Color(0xFF000000),
                          controller: _searchController,
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.search,
                                color: Color(0xFF000000).withOpacity(0.5),
                              ),
                              hintText: "Search By VRN",
                              border: InputBorder.none),
                        ),
                      ),
                    ),

                    Expanded(
                      child: ListView.builder(
                        controller: _controller,
                        itemCount: _vehicleList.length,
                        itemBuilder: (_, index) => Card(
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                          child: indexBuilder(context, index),
                        ),
                      ),
                    ),

                    // when the _loadMore function is running
                    if (_isLoadMoreRunning == true)
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 40),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),

                    // When nothing else to load
                    if (_hasNextPage == false)
                      Container(
                        padding: const EdgeInsets.only(top: 20, bottom: 20),
                        color: Colors.amber,
                        child: Center(
                          child: Text('You have fetched all of the Vehicle'),
                        ),
                      ),
                  ],
                ),
    );
  }



  Widget indexBuilder(BuildContext context,  int index) {
    final navigateTo = (page) => Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => page,
    ));
    final data = _vehicleList[index];
    return ListTile(
      onTap: () => {


    _displayOptionDialog(context,data.id!)

    //  navigateTo(VehicleInspectionList(vehicleID: data.id!))

      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: LayoutBuilder(
        builder: (context, constraint) {
          return Container(
              width: constraint.maxWidth,
              height: 100,
              child: Row(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child:
                      Text("$index", style: normalTextStyle)

                        /*Image.asset("assets/icons/ic_launcher.png",
                          width: 100, height: 100),*/
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 10, 5, 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: constraint.maxWidth - 130,
                          child: Text(data.vrn ?? 'N/A', style: subTitleStyle),
                        ),
                        Container(
                          width: constraint.maxWidth - 130,
                          child: Text('Type: ${data.type ?? 'N/A'}',
                              style: normalTextStyle),
                        ),
                        Container(
                          width: constraint.maxWidth - 130,
                          child: Text('Model: ${data.model ?? 'N/A'}',
                              style: normalTextStyle),
                        ),
                      ],
                    ),
                  ),
                ],
              ));
        },
      ),
    );
  }

  _displayOptionDialog(BuildContext context,int _vehicleID)  {

    final navigateTo = (page) => Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => page,
    ));
    showDialog(
        context: context,
        barrierDismissible: true,
      builder: (BuildContext context) {
        return  SimpleDialog(
            contentPadding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))
            ),
            title: Text('Select Option' ,style: TextStyle(

                fontSize: 20)),
            children:[

              SimpleDialogOption(
                padding: EdgeInsets.all(15),
              onPressed: () {
                Navigator.pop(context);
                navigateTo(VehicleInspectionList(vehicleID: _vehicleID));
              },
              child: const Text(ConstantData.vehicle_inspection,
                  style: TextStyle(fontSize: 15)),
            ),
              SimpleDialogOption(
                padding: EdgeInsets.all( 15),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(ConstantData.vehicle_detail,style: TextStyle(

                    fontSize: 15)),
              ),
            ],
            elevation: 10,
            //backgroundColor: Colors.green,

        );
      },
    );

  }
}

import 'package:flutter/material.dart';
import 'package:hnh_flutter/custom_style/colors.dart';
import 'package:hnh_flutter/custom_style/strings.dart';
import 'package:hnh_flutter/pages/vehicleInspection/create_inspection.dart';
import 'package:hnh_flutter/view_models/vehicle_inspection_list_vm.dart';

import '../../repository/model/request/vechicle_get_inspection_request.dart';
import '../../repository/model/response/vehicle_get_inspection_resposne.dart';
import '../../widget/navigation_drawer_widget.dart';

class VehicleInspectionList extends StatefulWidget {
  final int? vehicleID;

  // receive data from the FirstScreen as a parameter
  VehicleInspectionList({Key? key, @required this.vehicleID}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return VehicleInspectionListState(vehicleID ?? 0);
  }
}

class VehicleInspectionListState extends State<VehicleInspectionList> {
  bool _isFirstLoadRunning = false;
  bool _isErrorInApi = false;
  static bool _isInspectionViewOpen = false;

  List<Inspections> _vehicleInspectionListComplete = [];
  late BuildContext contextBuild;
  late VehicleInspectionListViewModel
      _vehicleListViewModel; //= VehicleInspectionListViewModel();
  var isResponseCompleted = false;
  int _vehicleID = 0;
  String vehicleInfoTitile = "";
  String intiatedStatus = "initiated";

  var textWidget = Expanded(
      child: Center(
          child: Text(
    'No Data Found',
    textAlign: TextAlign.center,
    textScaleFactor: 1.3,
    style: TextStyle(
      color: primaryTextColor,
    ),
  )));

  VehicleInspectionListState(int _vehicleID) {
    this._vehicleID = _vehicleID;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _isFirstLoadRunning = true;
      _isErrorInApi = false;
    });

    _vehicleListViewModel = VehicleInspectionListViewModel();

    var request = VechicleInspectionRequest();
    request.vehicleId = "$_vehicleID";
    _vehicleListViewModel.getInspectionVehicles(request);

    _vehicleListViewModel.addListener(() {
      isResponseCompleted = _vehicleListViewModel.getResponseStatus();
      if (isResponseCompleted) {
        final inspectionData = _vehicleListViewModel.getInspectionResponse();
        if (inspectionData == null) {
          setState(() {
            _isErrorInApi = true;
          });
        } else {
          _vehicleInspectionListComplete = inspectionData.vehicle!.inspections!;
          if (_vehicleInspectionListComplete.length == 0) {
            setState(() {
              _isErrorInApi = true;
            });
          } else {
            setState(() {
              _isErrorInApi = false;
            });
          }
        }

        setState(() {
          _isFirstLoadRunning = false;
          vehicleInfoTitile =
              "Inspection | ${inspectionData?.vehicle!.vrn} (${inspectionData?.vehicle!.make} ${inspectionData?.vehicle!.type})";
        });

        _vehicleListViewModel.setResponseStatus(false);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    contextBuild = context;
    return Scaffold(
      appBar: AppBar(
        title: Text(ConstantData.vehicle_inspection),
      ),
      drawer: NavigationDrawerWidget(),
      body:
      Column(
        children:[
      _isInspectionViewOpen
        ?
      CreateInspection("Create Inspection",_vehicleID, () {
      setState(() {
        _isInspectionViewOpen = false;
      });

    })
          : mainBody(context)
      ])


    );
  }

  Widget mainBody(BuildContext context)
  {
    return
      Expanded(child:
      _isFirstLoadRunning
        ? Center(
      child: CircularProgressIndicator(),
    )
        : Column(
      children: [
        Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(20),
            child: Text(vehicleInfoTitile,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18))),

        Container(
            alignment: Alignment.centerRight,
            padding:
            EdgeInsets.only(right: 10, bottom: 10),
            child: ElevatedButton.icon(
              icon: Icon(Icons.add),
              onPressed: () {
                setState(() {
                  _isInspectionViewOpen = true;
                });
              },
              style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all(
                      Colors.blueAccent),
                  textStyle: MaterialStateProperty.all(
                      TextStyle(fontSize: 12))),
              label: Text('Add Inspection'),
            )),
        _isErrorInApi
            ? textWidget
            : Expanded(
          child: ListView.builder(
            itemCount:
            _vehicleInspectionListComplete
                .length,
            itemBuilder: (_, index) => Container(
              margin: EdgeInsets.symmetric(
                  vertical: 8, horizontal: 10),
              child: indexBuilder(context, index),
            ),
          ),
        )
      ],


    ));
  }
  Widget indexBuilder(BuildContext context, int index) {
    final data = _vehicleInspectionListComplete[index];
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: LayoutBuilder(
        builder: (context, constraint) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Table(
              columnWidths: const {
                0: FixedColumnWidth(150),
                1: FlexColumnWidth(),
              },
              children: [
                TableRow(children: [
                  Container(
                      padding: const EdgeInsets.all(15),
                      child: Text('Date',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Container(
                      decoration: BoxDecoration(
                        color: inspectionTableColor,
                        border: Border.all(
                          width: 0,
                        ),
                        borderRadius:
                            BorderRadius.only(topRight: Radius.circular(10)),
                      ),
                      padding: const EdgeInsets.all(15),
                      child: Text("${data.date}"))
                ]),
                TableRow(children: [
                  Container(
                      padding: const EdgeInsets.all(15),
                      child: Text('Type',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Container(
                      color: inspectionTableColor,
                      padding: const EdgeInsets.all(15),
                      child: Text("${data.type}"))
                ]),
                TableRow(children: [
                  Container(
                      padding: const EdgeInsets.all(15),
                      child: Text('Status',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Container(
                      color: inspectionTableColor,
                      padding: const EdgeInsets.all(15),
                      child: Text("${data.status}"))
                ]),
                TableRow(children: [
                  Container(
                      padding: const EdgeInsets.all(15),
                      child: Text('Vehicle Type',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Container(
                      color: inspectionTableColor,
                      padding: const EdgeInsets.all(15),
                      child: Text("${data.vehicleType}"))
                ]),
                TableRow(children: [
                  Container(
                      padding: const EdgeInsets.all(15),
                      child: Text('Action',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Container(
                      padding: const EdgeInsets.all(5),
                      child: Wrap(children: [
                        if (data.status == intiatedStatus)
                          ElevatedButton.icon(
                            icon: Icon(Icons.save),
                            onPressed: () {},
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.amber),
                                textStyle: MaterialStateProperty.all(
                                    TextStyle(fontSize: 12))),
                            label: Text('Complete Inspection'),
                          )
                        else
                          ElevatedButton(
                            onPressed: () {},
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.green),
                                textStyle: MaterialStateProperty.all(
                                    TextStyle(fontSize: 12))),
                            child: Text('Completed'),
                          )
                      ]))
                ])
              ],
              border: TableBorder.symmetric(
                inside: BorderSide(width: 1),
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hnh_flutter/custom_style/colors.dart';
import 'package:hnh_flutter/custom_style/strings.dart';
import 'package:hnh_flutter/custom_style/text_style.dart';
import 'package:hnh_flutter/pages/vehicleInspection/inspection_check.dart';
import 'package:hnh_flutter/view_models/vehicle_inspection_list_vm.dart';
import 'package:intl/intl.dart';

import '../../widget/dialog_builder.dart';
import '../../repository/model/request/create_inspection_request.dart';
import '../../repository/model/request/vechicle_get_inspection_request.dart';
import '../../repository/model/response/vehicle_get_inspection_resposne.dart';
import '../../widget/navigation_drawer_new.dart';
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
  bool _moveToNextScreen = false;

  VehicleInspectionListState(int _vehicleID) {
    this._vehicleID = _vehicleID;
  }

  CreateInspectionRequest requestBody = CreateInspectionRequest();

  final TextEditingController _odoMeterController = TextEditingController();
  String date = "";
  DateTime selectedDate = DateTime.now();

  List<String> spinnerItems = [
    'Select inspection type',
    'initial-safety-inspection',
    'weekly-safety-check',
    'pre-mot-inspection'
  ];

  String initialSelection = "Select inspection type";
  String dropdownValue = "";

  String? _errorMsg = "";
  DialogBuilder? _progressDialog;

  @override
  void initState() {
    super.initState();

    _progressDialog = DialogBuilder(context);
    _progressDialog?.initiateLDialog('Please wait..');

    setState(() {
      dropdownValue = initialSelection;
      _isFirstLoadRunning = true;
      _isErrorInApi = false;
      _isInspectionViewOpen = false;
      _moveToNextScreen =false;
    });

    _vehicleListViewModel = VehicleInspectionListViewModel();

    var request = VechicleInspectionRequest();
    request.vehicleId = "$_vehicleID";
    _vehicleListViewModel.getInspectionVehicles(request);

    _vehicleListViewModel.addListener(() {
      isResponseCompleted = _vehicleListViewModel.getResponseStatus();
      if (isResponseCompleted) {
        var checkErrorApiStatus = _vehicleListViewModel.getIsErrorRecevied();
        if (checkErrorApiStatus) {
          setState(() {
            _isErrorInApi = checkErrorApiStatus;
            _errorMsg = _vehicleListViewModel.getErrorMsg();
          });
        } else {
          _vehicleInspectionListComplete =
              _vehicleListViewModel.getVehicleInspectionList();
          if (_vehicleInspectionListComplete.isEmpty) {
            setState(() {
              _isErrorInApi = true;
              _errorMsg = "No data found";
            });
          } else {
            _isErrorInApi = checkErrorApiStatus;
            _errorMsg = "";
          }
        }
        setState(() {
          _isFirstLoadRunning = false;
          vehicleInfoTitile = _vehicleListViewModel.getVehicleName();
        });

        if (_vehicleListViewModel.checkIsInspectionCreated()) {
          _showDialog(context, "Vehicle Inspection is created successfully");
          _vehicleListViewModel.setInspectionCreated(false);
        }



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
    return Scaffold(

      appBar: AppBar(
        title: Text(ConstantData.vehicle_inspection),
      ),
      //drawer: NavigationDrawer(),
      body:
      Column(
        children:[
      _isInspectionViewOpen
        ?
      inspectionCreateWidget(context)
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
                style:titleTextStyle)),

        Container(
            alignment: Alignment.centerRight,
            padding:
            EdgeInsets.only(right: 10, bottom: 10),
            child: ElevatedButton.icon(
              icon: Icon(Icons.add),
              onPressed: () {
                setState(() {
                  _isInspectionViewOpen = true;
                    dropdownValue = initialSelection;
                    _odoMeterController.text = "";
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
                      ? Expanded(
                          child: Center(
                              child: Text(
                          '$_errorMsg',
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.3,
                          style:errorTextStyle
                        )))
                      : Expanded(
                          child: ListView.builder(
                            itemCount: _vehicleInspectionListComplete.length,
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
                0: FixedColumnWidth(170),
                1: FlexColumnWidth(),
              },
              children: [
                TableRow(children: [
                  Container(
                      padding: const EdgeInsets.all(15),
                      child: Text('Created At',
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

                      //DateFormat('yyyy-MM-dd HH:mm:ss').parse(data.createdAt!)}
                      child: Text("${ DateFormat('yyyy-MM-dd  hh:mm a').
                      format(DateTime.parse(data.createdAt!).toLocal())}"
                      )
                  )
                ]),
                TableRow(children: [
                  Container(
                      padding: const EdgeInsets.all(15),
                      child: Text('Inspection Date',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Container(
                      color: inspectionTableColor,
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
                            onPressed: () {
                              final navigateTo = (page) =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => page,
                                  ));
                              navigateTo(
                                  InspectionCheck(inspectionID: data.id,

                                     onApiExecutedSuccessfully:(){

                                       setState(() {
                                         dropdownValue = initialSelection;
                                         _isFirstLoadRunning = true;
                                         _isErrorInApi = false;
                                         _isInspectionViewOpen = false;
                                         _moveToNextScreen =false;

                                         var request = VechicleInspectionRequest();
                                         request.vehicleId = "$_vehicleID";
                                         _vehicleListViewModel.getInspectionVehicles(request);
                                       });



                                      }
                                  ));
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.amber),
                                textStyle: MaterialStateProperty.all(
                                    TextStyle(fontSize: 12))),
                            label: Text('Continue Inspection',style:TextStyle(color: Colors.black)),
                          )
                        else
                          ElevatedButton(
                            onPressed: () {


                            },
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

  Widget inspectionCreateWidget(BuildContext context) {
    return Expanded(
        child: SingleChildScrollView(
            child: Column(
      children: [
        /* Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(20),
                    child: Text(title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18))),*/

        Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Inspection Information",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),
                Divider(color: Colors.black),
                SizedBox(height: 15),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Inspection Type *",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        underline: SizedBox(),
                        onChanged: (data) {
                          setState(() {
                            dropdownValue = data!;
                          });

                          requestBody.type = data!;
                        },
                        items: spinnerItems
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ]),
                ),
                SizedBox(height: 25),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Inspection Date *",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        child: new InkWell(
                            onTap: () {
                              _selectDate(context);
                            },
                            child: Row(
                              children: [
                                Text(
                                    selectedDate ==
                                            null //ternary expression to check if date is null
                                        ? 'No date was chosen!'
                                        : "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(width: 50),
                                IconButton(
                                  icon: Icon(Icons.calendar_today),
                                  onPressed: () {
                                    _selectDate(context);
                                  },
                                ),
                              ],
                            ))),
                  ]),
                ),
                SizedBox(height: 25),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Odometer Reading *",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TextField(
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                    ],
                    controller: _odoMeterController,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: textFielBoxFillColor,
                        hintText: 'Enter Odo Reading',
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: textFielBoxBorderColor, width: 1.0)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: textFielBoxBorderColor, width: 1.0))),
                  ),
                ),
              ],
            )),
        SizedBox(
          height: 20,
        ),
        Container(
            padding: EdgeInsets.only(left: 15, bottom: 10),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isInspectionViewOpen = false;
                    });
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.grey),
                      textStyle:
                          MaterialStateProperty.all(TextStyle(fontSize: 12))),
                  child: Text('Cancel'),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    requestBody.odometerReading = _odoMeterController.text;

                    if (requestBody.type == null ||
                        requestBody.type!.isEmpty ||
                        requestBody.type! == initialSelection) {
                      _showToast(context, "Type missing");
                    } else if (requestBody.odometerReading == null ||
                        requestBody.odometerReading!.isEmpty) {
                      _showToast(context, "odometer reading missing");
                    } else {
                      _progressDialog?.showLoadingDialog();
                      requestBody.date =
                          "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
                      requestBody.vehicleId = "$_vehicleID";
                      setState(() {
                        _isFirstLoadRunning = true;
                        _isErrorInApi = false;
                      });
                      _vehicleListViewModel
                          .createVehicleInspection(requestBody);
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      textStyle:
                          MaterialStateProperty.all(TextStyle(fontSize: 12))),
                  child: Text('Create'),
                ),
              ),
            ])),
      ],
    )));
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2035),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
      });

    // Text("${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"),
  }

  void _showToast(BuildContext context, String text) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(text),
        action: SnackBarAction(
            label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  void _showDialog(BuildContext context, String msg) {
    _progressDialog?.hideOpenDialog();

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: new Text(msg),
          actions: <Widget>[
            FlatButton(
              child: new Text("Close"),
              onPressed: () {
                setState(() {
                  _isInspectionViewOpen = false;
                  _isFirstLoadRunning= true;
                  _isErrorInApi =false;
                });
                Navigator.of(context).pop();
                var request = VechicleInspectionRequest();
                request.vehicleId = "$_vehicleID";
                _vehicleListViewModel.getInspectionVehicles(request);
              },
            ),
          ],
        );
      },
    );
  }



}

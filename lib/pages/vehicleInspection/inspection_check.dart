import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hnh_flutter/custom_style/colors.dart';
import 'package:hnh_flutter/repository/model/request/inspection_check_request.dart';
import 'package:hnh_flutter/repository/model/request/save_inspection_request.dart';
import 'package:hnh_flutter/repository/model/response/get_inspection_check_api_response.dart';
import 'package:hnh_flutter/view_models/get_inspection_vm.dart';

import '../../custom_style/strings.dart';

class InspectionCheck extends StatefulWidget {
  final int? inspectionID;

  const InspectionCheck({Key? key, @required this.inspectionID})
      : super(key: key);

  @override
  State<InspectionCheck> createState() => InspectionCheckStateful();
}

class InspectionCheckStateful extends State<InspectionCheck> {
  String inspectionText = "Inspection completed: ";
  String titlePage = "";
  List<String> questions = ["estq", "test2"];

  int _groupValue = 0;

  GetInspectionCheckViewModel _getInspectionCheckViewModel =
      GetInspectionCheckViewModel();
  bool _isFirstLoadRunning = false;
  bool _isErrorInApi = false;
  String? _errorMsg = "";
  final TextEditingController _commentController = TextEditingController();
  Vehicle? _vehicleData;
  Inspection? _inspectionData;
  Check? _checkData;
  List<CheckOptions>? _radioOptions;

  int _totalCheckCount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      _isFirstLoadRunning = true;
      _isErrorInApi = false;
    });

    callGetApiData(0);
  }

  callGetApiData(int checkNo) async {
    CheckInspectionRequest request = CheckInspectionRequest();
    request.vehicleInspectionId = '${widget.inspectionID}';
    request.checkNo = checkNo;

    _getInspectionCheckViewModel.getInspectionCheck(request);
    _getInspectionCheckViewModel.addListener(() {
      var isResponseCompleted =
          _getInspectionCheckViewModel.getResponseStatus();
      if (isResponseCompleted) {
        var checkErrorApiStatus =
            _getInspectionCheckViewModel.getIsErrorRecevied();
        if (checkErrorApiStatus) {
          setState(() {
            _isErrorInApi = checkErrorApiStatus;
            _errorMsg = _getInspectionCheckViewModel.getErrorMsg();
          });
        } else {
          setState(() {
            _isFirstLoadRunning = false;
            _isErrorInApi = checkErrorApiStatus;
            _errorMsg = "";
            _radioOptions = _getInspectionCheckViewModel.getRadioOptions();
            _vehicleData = _getInspectionCheckViewModel.getVehicleData();
            _inspectionData = _getInspectionCheckViewModel.getInspectionData();
            _checkData = _getInspectionCheckViewModel.getCheckData();
            _totalCheckCount =
                _getInspectionCheckViewModel.getTotalCheckCount();
            titlePage =
                "$inspectionText ${(_checkData!.checkNo! - 1)}/${_totalCheckCount}";
            _groupValue = 0;
          });
          Solved? solved =
              _getInspectionCheckViewModel.getAlreadySolvedComments();
          if (solved != null) {
            String? comment=solved.comment;
            if (comment == null) {
              _commentController.text = '';
            } else {
              _commentController.text = comment;
            }
            for (int i = 0; i < _radioOptions!.length; i++) {
              if (_radioOptions![i].id == solved.code) {
                _groupValue = i;
                return;
              }
            }
          }
          _getInspectionCheckViewModel.setResponseStatus(false);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        title: const Text(ConstantData.inspection),
      ),
      body: _isErrorInApi
          ? Center(
              child: Text(
              '$_errorMsg',
              textAlign: TextAlign.center,
              textScaleFactor: 1.3,
              style: TextStyle(color: Colors.red, fontSize: 16),
            ))
          : _isFirstLoadRunning
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : createFirstView(context),
    );
  }

  Widget createFirstView(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(20),
            child: Text(titlePage,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
        Padding(
            padding: EdgeInsets.all(10),
            child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: inspectionTableColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  children: [
                    createBasicTitle(
                        "Vehicle Reg:	", _vehicleData?.vrn ?? 'N/A'),
                    createBasicTitle("Model:	", _vehicleData?.model ?? 'N/A'),
                    createBasicTitle("Odometer Reading:	",
                        _inspectionData?.odometerReading ?? 'N/A'),
                    createBasicTitle(
                        "Inspection Date:	", _inspectionData?.date ?? 'N/A'),
                    SizedBox(
                      height: 20,
                    ),
                    Divider(
                      height: 1,
                      color: Colors.black,
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              _checkData?.type ?? 'N/A',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ))),
                    Divider(
                      height: 1,
                      color: Colors.black,
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.15,
                                      child: Text(
                                        "Check No:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      child:
                                          Text("${_checkData!.checkNo ?? '0'}"),
                                    ),
                                  ],
                                )),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.15,
                                      child: Text(
                                        "Imf Ref:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      child: Text("10"),
                                    ),
                                  ],
                                ))
                          ],
                        )),
                    Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                child: Row(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  child: Text(
                                    "Item Inspected:",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  child: Text("${_checkData!.name ?? 'N/A'}"),
                                ),
                              ],
                            )),
                          ],
                        )),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Inspection Code *",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: [
                            for (int i = 0; i < _radioOptions!.length; i++)
                              _buildItem(_radioOptions![i].value!, i),
                          ],
                        )),
                    if (_groupValue > 0) _showCommentBox(),
                    Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                            padding: const EdgeInsets.only(right: 10, top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (_checkData!.checkNo! > 1)
                                  SizedBox(
                                    //height of button
                                    width: 100,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _isFirstLoadRunning = true;
                                          _isErrorInApi = false;
                                        });
                                        callGetApiData(
                                            _checkData!.checkNo! - 1);
                                      },
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.blueGrey),
                                          textStyle: MaterialStateProperty.all(
                                              TextStyle(fontSize: 12))),
                                      child: Text('Previous'),
                                    ),
                                  ),
                                Padding(padding: EdgeInsets.only(right: 20)),
                                SizedBox(
                                  //height of button
                                  width: 100,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      saveCheckAndLoadNext();
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.blue),
                                        textStyle: MaterialStateProperty.all(
                                            TextStyle(fontSize: 12))),
                                    child: Text('Next'),
                                  ),
                                ),
                              ],
                            ))),
                  ],
                )))
      ],
    ));
  }

  Widget _showCommentBox() {
    return Padding(
        padding: EdgeInsets.only(bottom: 20, top: 10),
        child: Column(
          children: [
            Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Comment *",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: textFielBoxFillColor,
                    hintText: 'Enter your comment',
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
        ));
  }

  Widget createBasicTitle(String title, String value) {
    return Column(
      children: [
        SizedBox(height: 10),
        Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              child: Text(value),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildItem(String text, int value) {
    return SizedBox(
        height: 35,
        child: ListTile(
          title: Row(
            children: <Widget>[
              Radio(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: value,
                groupValue: _groupValue,
                onChanged: (int? value) {
                  _handleRadioValueChange(value!);
                },
              ),
              Text(
                text,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ));
  }

  _handleRadioValueChange(int value) {
    setState(() {
      _groupValue = value;
      _commentController.text = "";
    });
  }

  void saveCheckAndLoadNext() async {
    SaveInspectionCheckRequest request = SaveInspectionCheckRequest();
    request.checkNo = "${_checkData!.checkNo}";
    request.vehicleInspectionId = "${_inspectionData!.id}";
    request.type = "${_checkData!.type}";
    request.code = "${_radioOptions![_groupValue].id}";
    request.name = "${_checkData!.name}";
    request.comment = "";

    if (_groupValue > 0) {
      if (_commentController.text.isEmpty) {
        _showToast(context, "Please enter your comment");
      } else {
        request.comment = _commentController.text;
        setState(() {
          _isFirstLoadRunning = true;
          _isErrorInApi = false;
        });
        _callSaveInspectionApi(request,_checkData!.checkNo! + 1);
      }
    } else {
      _callSaveInspectionApi(request,_checkData!.checkNo! + 1);
    }
  }


  _callSaveInspectionApi(SaveInspectionCheckRequest request,int check) async
  {
    setState(() {
      _isFirstLoadRunning = true;
      _isErrorInApi = false;
    });
    await _getInspectionCheckViewModel.saveInspectionCheck(request);
    if (_getInspectionCheckViewModel.getInspectionCompleted()) {
      _showDialog(context, "Inspection Completed");
    } else {
      callGetApiData(check);
    }
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

  void _showDialog(BuildContext _context, String msg) {
    BuildContext   dialogContext;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        dialogContext = context;
        return AlertDialog(

          content: new Text(msg),
          actions: <Widget>[
            FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.pop(_context, true) ;
              },
            ),

          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hnh_flutter/custom_style/colors.dart';
import 'package:hnh_flutter/repository/model/request/inspection_check_request.dart';
import 'package:hnh_flutter/repository/model/request/save_inspection_request.dart';
import 'package:hnh_flutter/repository/model/response/get_inspection_check_api_response.dart';
import 'package:hnh_flutter/view_models/get_inspection_vm.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../custom_style/strings.dart';
import '../../custom_style/text_style.dart';
import '../../repository/model/request/save_inspection_post_data.dart';

class InspectionCheck extends StatefulWidget {
  final int? inspectionID;
  final VoidCallback onApiExecutedSuccessfully;
  const InspectionCheck({Key? key, @required this.inspectionID,required this.onApiExecutedSuccessfully})
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
  Checks? _checkData;
  List<CheckOptions>? _radioOptions;

  int _totalCheckCount = 0;
  int _checkIndex = 0;



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

            _totalCheckCount =
                _getInspectionCheckViewModel.getTotalCheckCount();

            _groupValue = 0;


            _getCheckData(_checkIndex);
          });

          _getInspectionCheckViewModel.setResponseStatus(false);
        }
      }
    });
  }

  _getCheckData(int index) {
    //**************** Listing of checks ***///////
    setState(() {
      titlePage = "$inspectionText ${_checkIndex}/${_totalCheckCount}";
      _groupValue=0;
      _commentController.text = '';
    });

    _getInspectionCheckViewModel.getCheckDataFromIndex(index);
    _checkData = _getInspectionCheckViewModel.getCheckData();
    if (_checkData!.savedInspections!.length > 0) {
      SavedInspections? solved =
          _getInspectionCheckViewModel.getSavedInspection();
      if (solved != null) {
        String? comment = solved.comment;
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () async {
                  bool isExit = await _onWillPop();
                  if (isExit == true) {
                    Navigator.of(context).pop();
                  }
                }),
            title: const Text(ConstantData.inspection),
          ),
          body: _isErrorInApi
              ? Center(
                  child: Text(
                  '$_errorMsg',
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.3,
                  style:errorTextStyle,
                ))
              : _isFirstLoadRunning
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : createFirstView(context),
        ));
  }

  Widget createFirstView(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(20),
            child: Text(titlePage,
                style: titleTextStyle)),


        _showHorizontalProgress(),


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
                              style: normalBoldTextStyle,
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
                                        style: normalBoldTextStyle,
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
                                        style: normalBoldTextStyle,
                                      ),
                                    ),
                                    Container(
                                      child:   Text("${_checkData!.imRef=='' ? 'N/A': _checkData!.imRef}"),

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
                              child: Expanded(
                                  child: Row(
                            children: [
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  child: Text(
                                    "Item Inspected:",
                                    style:
                                    normalBoldTextStyle,
                                  )),
                              Container(
                                  child: Expanded(
                                      child: Text(
                                "${_checkData!.name ?? 'N/A'}",
                              ))),
                            ],
                          ))),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Inspection Code *",
                        style: normalBoldTextStyle,
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
                                        saveVehicleInspectionChecks(true);
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
                                      saveVehicleInspectionChecks(false);
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.blue),
                                        textStyle: MaterialStateProperty.all(
                                            TextStyle(fontSize: 12))),
                                    child: Text(_checkIndex == _totalCheckCount-1 ?'Finish':'Next'),
                                  ),
                                ),
                              ],
                            ))),
                  ],
                )))
      ],
    ));
  }


Widget _showHorizontalProgress()
{
  return  Container(
    margin: EdgeInsets.only(left: 10,right: 10),
    alignment:Alignment.center,
    child: LinearPercentIndicator( //leaner progress bar
      animation: false,
      lineHeight: 15.0,

      percent: (_checkIndex/_totalCheckCount),
      linearStrokeCap: LinearStrokeCap.roundAll,
      progressColor: Colors.blue[400],
      backgroundColor: Colors.grey[300],
    ),
  );


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
                  style: normalBoldTextStyle,
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
                style: normalBoldTextStyle,
              ),
            ),
            Container(
              child: Text(value,style: normalTextStyle,),
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
                style: normalTextStyle,
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

  void saveVehicleInspectionChecks(bool _isPreviousIndex) {
    SolvedChecked solvedChecked = SolvedChecked();
    solvedChecked.checkNo = _checkData!.checkNo;
    solvedChecked.vehicleInspectionId = "${_inspectionData!.id}";
    solvedChecked.type = "${_checkData!.type}";
    solvedChecked.code = "${_radioOptions![_groupValue].id}";
    solvedChecked.name = "${_checkData!.name}";
    solvedChecked.comment = "";

    if (_groupValue > 0) {
      if (_commentController.text.isEmpty) {
        _showToast(context, "Please enter your comment");
      } else {
        solvedChecked.comment = _commentController.text;

        _callSaveInspectionApi(solvedChecked, _isPreviousIndex);
      }
    } else {
      _callSaveInspectionApi(solvedChecked, _isPreviousIndex);
    }
  }

  _callSaveInspectionApi(SolvedChecked solvedChecked, bool _isPreviousIndex) {

    //Update list in view model class
    Checks checks = Checks();
    var inspectionData = SavedInspections();

    inspectionData.code = solvedChecked.code;
    inspectionData.comment = solvedChecked.comment;
    inspectionData.imRef = "";
    inspectionData.name = solvedChecked.name;
    inspectionData.checkNo = solvedChecked.checkNo;
    inspectionData.vehicleInspectionId = int.parse(solvedChecked.vehicleInspectionId!);
    inspectionData.type = solvedChecked.type;

    checks.name = solvedChecked.name;
    checks.type =  solvedChecked.type;
    checks.imRef = _checkData!.imRef;
    checks.checkNo = solvedChecked.checkNo;
    checks.savedInspections = [inspectionData];

    var listData = _getInspectionCheckViewModel.checkList;

    listData[_checkIndex] = checks;

    _getInspectionCheckViewModel.setCheckList(listData);

    // *********************************************//



    if (_isPreviousIndex) {
      if (_checkIndex >= 0) {
        setState(() {
          _checkIndex--;
        });
      }
    } else {
      if (_checkIndex < (_totalCheckCount-1)) {
        setState(() {
          _checkIndex++;
        });
      }
      else{
        print(_checkIndex);
        setState(() async{
          _isFirstLoadRunning = true;
          _isErrorInApi = false;

          var _apiPostData = PostInspectionData();
          _apiPostData.inspectionId = widget.inspectionID;
          _apiPostData.checks = _getInspectionCheckViewModel.checkList;
         await _getInspectionCheckViewModel.saveInspectionCheck(_apiPostData);

          _showDialog(context,"Inspection Completed Successfully!!");

        });
      }
    }



    _getCheckData(_checkIndex);
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
                widget.onApiExecutedSuccessfully();
                Navigator.pop(dialogContext);
                Navigator.pop(_context, true);
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to save your inspection'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () async {

                            setState(() {
                    _isFirstLoadRunning = true;
                _isErrorInApi = false;

                    var _apiPostData=  PostInspectionData();
                    _apiPostData.inspectionId=widget.inspectionID;
                    _apiPostData.checks=_getInspectionCheckViewModel.checkList;
                    _getInspectionCheckViewModel.saveInspectionCheck(_apiPostData);


               });



                     Navigator.of(context).pop(true);
                     widget.onApiExecutedSuccessfully();
                },
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }
}

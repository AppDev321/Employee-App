import 'dart:async';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hnh_flutter/custom_style/colors.dart';

import '../../custom_style/strings.dart';
import '../../data/drawer_items.dart';
import '../../utils/controller.dart';
import '../../view_models/attendance_vm.dart';
import '../../widget/dialog_builder.dart';
import '../../widget/error_message.dart';

class VehicleTabScan extends StatefulWidget {
  const VehicleTabScan({Key? key}) : super(key: key);

  @override
  State<VehicleTabScan> createState() => _VehicleTabScanState();
}

class _VehicleTabScanState extends State<VehicleTabScan> {
  String? _errorMsg = "";
  DialogBuilder? _progressDialog;
  late AttendanceViewModel attendanceViewModel;
  BuildContext? _dialogContext;

  bool c = false;
  bool _isErrorInApi = false;

  Future<void> scanAttendanceCode() async {
    AppBar(
      backgroundColor: primaryColor,
      title: const Text(
        'Scanning Code',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white),
      ),
      centerTitle: true,
    );
    try {
      var qrResult = await BarcodeScanner.scan();

      _progressDialog?.showLoadingDialog();
      attendanceViewModel.verifyVehicleTab(qrResult.rawContent);
    } on FormatException catch (ex) {
      print('Pressed the Back Button before Scanning');
    } catch (ex) {
      print('Unknown Error $ex');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    attendanceViewModel = AttendanceViewModel();

    attendanceViewModel.addListener(() {
      _progressDialog?.hideOpenDialog();

      var checkErrorApiStatus = attendanceViewModel.getIsErrorRecevied();
      if (checkErrorApiStatus) {
        setState(() {
          _errorMsg = attendanceViewModel.getErrorMsg();
          if (_errorMsg!.contains(ConstantData.unauthenticatedMsg)) {
            Controller().logoutUser();
          } else {
            Controller().showToastMessage(context, _errorMsg!);
          }
        });
      } else {
        if (attendanceViewModel.getRequestStatus()) {
          setState(() {
            _errorMsg = "";
            _isErrorInApi = false;
          });

          Controller()
              .showToastMessage(context, "Request submitted successfully");
          // Navigator.pop(context);
          Get.back();
        } else {
          _errorMsg = attendanceViewModel.getErrorMsg();

          if (_errorMsg!.contains(ConstantData.unauthenticatedMsg)) {
            Controller().logoutUser();
          } else {
            Controller().showToastMessage(context, _errorMsg!);
            setState(() {
              _isErrorInApi = true;
            });
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _dialogContext = context;
    if (_progressDialog == null) {
      _progressDialog = DialogBuilder(_dialogContext!);
      _progressDialog?.initiateLDialog('Please wait..');
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(menuScanVehicleTab),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Scan QR-Code',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26.0,
                    color: Color(0xFF1E1E1E)),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(50.0, 5.0, 50.0, 20.0),
              child: const Text(
                'Please give access to your Camera so that\n we can scan and provide you what is\n inside the code',
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: 1.4,
                  color: Color(0xFFA0A0A0),
                ),
              ),
            ),
            _isErrorInApi
                ? Column(
                    children: [
                      SizedBox(
                        height: 80,
                      ),
                      Align(
                        alignment: Alignment.center,
                          child: Container(

                              margin: EdgeInsets.all(20),
                              child: ErrorMessageWidget(
                                label: _errorMsg!,
                                color: Colors.red,
                              )))
                    ],
                  )
                : Center(),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SizedBox(
          height: 60.0,
          width: double.infinity,
          child: FloatingActionButton.extended(
            onPressed: scanAttendanceCode,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            backgroundColor: primaryColor,
            label: Text(
              "Scan QR Code",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

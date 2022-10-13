import 'dart:async';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hnh_flutter/custom_style/colors.dart';
import 'package:hnh_flutter/data/drawer_items.dart';

import '../../custom_style/strings.dart';
import '../../utils/controller.dart';
import '../../view_models/attendance_vm.dart';
import '../../widget/dialog_builder.dart';

class AddAttendance extends StatefulWidget {

  final int? attendanceType  ; //0 - check in ,1 - check out
  AddAttendance({Key? key,  this.attendanceType =0}) : super(key: key);



  @override
  State<AddAttendance> createState() => _AddAttendanceState();
}

class _AddAttendanceState extends State<AddAttendance> {
  String? _errorMsg = "";
  DialogBuilder? _progressDialog;
  late AttendanceViewModel attendanceViewModel;
  BuildContext? _dialogContext;

  Future<void> scanAttendanceCode() async {
    AppBar(
      backgroundColor: primaryColor,
      title: const Text(
        'Scanning Code',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
      ),
      centerTitle: true,
    );
    try {
      var qrResult = await BarcodeScanner.scan();

      _progressDialog?.showLoadingDialog();

    attendanceViewModel.markAttendanceRequest(qrResult.rawContent,  widget.attendanceType!);
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

    print("Type:${widget.attendanceType}");

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
          });

          Controller() .showToastMessage(context, "Request submitted successfully");
         Navigator.pop(context);
          Get.back();

         // Get.to(() => const AttendanceReport());
        } else {
          _errorMsg = attendanceViewModel.getErrorMsg();
          if (_errorMsg!.contains(ConstantData.unauthenticatedMsg)) {
            Controller().logoutUser();
          } else {
            Controller().showToastMessage(context, _errorMsg!);
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
    var colorText = Get.isDarkMode ? blackThemeTextColor : Colors.black;
    return Scaffold(
      appBar: AppBar(
        title: const Text(menuAttandance),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Scan QR-Code',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colorText,
                  fontWeight: FontWeight.bold,
                  fontSize: 26.0,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(50.0, 5.0, 50.0, 20.0),
              child: Text(
                'Please give access to your Camera so that\n we can scan and provide you what is\n inside the code',
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: 1.4,
                  color: colorText,
                ),
              ),
            ),
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
            label: const Text(
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

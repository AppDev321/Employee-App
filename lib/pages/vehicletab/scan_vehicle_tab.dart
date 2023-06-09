import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hnh_flutter/custom_style/colors.dart';
import 'package:hnh_flutter/repository/model/response/qr_scan_data.dart';
import 'package:hnh_flutter/view_models/profile_vm.dart';

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
  String uploadId = "";

  bool c = false;
  bool _isErrorInApi = false;

  var userPicturePath = "";

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
      //   var qrResult = await BarcodeScanner.scan();
      //    _progressDialog?.showLoadingDialog();
      //    attendanceViewModel.verifyVehicleTab(qrResult.rawContent,uploadId);

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AiBarcodeScanner(
            onScan: (String value) {
              Controller().printLogs("barcode= $value");
              uploadId = "${DateTime.now().millisecondsSinceEpoch}";
              _progressDialog?.showLoadingDialog();
              if (Controller().isValid("BASE64",value) == true) {
                String decoded = utf8.decode(base64Url.decode(value));
                Map<String, dynamic> valueMap = json.decode(decoded);
                QrScanData qrScanData = QrScanData.fromJson(valueMap);
                Controller().printLogs("qr data: ${qrScanData.toJson()}");
                attendanceViewModel.verifyWebLogin(qrScanData.code.toString());
              } else {
                attendanceViewModel.verifyVehicleTab(value, uploadId);
              }
            },
          ),
        ),
      );
    } on FormatException catch (ex) {
      Controller().printLogs('Pressed the Back Button before Scanning');
    } catch (ex) {
      Controller().printLogs('Unknown Error $ex');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    attendanceViewModel = AttendanceViewModel();
    //attendanceViewModel.takeUserPictureWithoutPreview();

    attendanceViewModel.addListener(() {
      userPicturePath = attendanceViewModel.userPicturePath;

      if (userPicturePath.isNotEmpty) {
        var profileViewModel = ProfileViewModel();
        profileViewModel.uploadImageToServer(
            context, File(userPicturePath), (isUploaded) {}, (imageUrl) {
          Controller().printLogs(imageUrl);
          uploadId = imageUrl;
        },
            requestType: "qr_scan",
            isReturnPath: false,
            showUploadAlertMsg: false);
      }

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
          Get.back();
          Controller()
              .showToastMessage(context, "Request submitted successfully");
          //   Navigator.pop(context);

        } else {
          _errorMsg = attendanceViewModel.getErrorMsg();
          if (_errorMsg?.isNotEmpty == true) {
            if (_errorMsg!.contains(ConstantData.unauthenticatedMsg)) {
              Controller().logoutUser();
            } else {
              if (mounted) {
                Controller().showToastMessage(context, _errorMsg!);
                setState(() {
                  _isErrorInApi = true;
                });
              }
            }
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
        title: const Text(menuScanVehicleTab),
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
                    fontWeight: FontWeight.bold,
                    fontSize: 26.0,
                    color: colorText),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(50.0, 5.0, 50.0, 20.0),
              child: Text(
                'Please give access to your Camera so that  we can scan and provide you what is  inside the code',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colorText,
                  height: 1.4,
                ),
              ),
            ),
            _isErrorInApi
                ? Column(
                    children: [
                      const SizedBox(
                        height: 80,
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: Container(
                              margin: const EdgeInsets.all(20),
                              child: ErrorMessageWidget(
                                label: _errorMsg!,
                                color: Colors.red,
                              )))
                    ],
                  )
                : const Center(),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SizedBox(
          height: 60.0,
          width: double.infinity,
          child: FloatingActionButton.extended(
            onPressed: () {
              scanAttendanceCode();
            },
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

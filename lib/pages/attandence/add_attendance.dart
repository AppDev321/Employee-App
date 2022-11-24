import 'dart:async';
import 'dart:io';
import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hnh_flutter/custom_style/colors.dart';
import 'package:hnh_flutter/data/drawer_items.dart';
import '../../custom_style/strings.dart';
import '../../main.dart';
import '../../utils/controller.dart';
import '../../view_models/attendance_vm.dart';
import '../../view_models/profile_vm.dart';
import '../../widget/dialog_builder.dart';

class AddAttendance extends StatefulWidget {
  final int? attendanceType; //0 - check in ,1 - check out
  AddAttendance({Key? key, this.attendanceType = 0}) : super(key: key);

  @override
  State<AddAttendance> createState() => _AddAttendanceState();
}

class _AddAttendanceState extends State<AddAttendance> {
  String? _errorMsg = "";
  DialogBuilder? _progressDialog;
  late AttendanceViewModel attendanceViewModel;
  BuildContext? _dialogContext;
  var userPicturePath = "";
  String uploadId = "";

  late CameraController cameraController;
  late Future<void> cameraValue;

  void startCamera()async{
    _progressDialog?.showLoadingDialog();
    cameraController.takePicture().then((XFile file) {
      if(mounted){
        if(file!=null){
          print("Image is saved in ${file.path}");
          userPicturePath=file.path;
          if (userPicturePath.isNotEmpty) {
            var profileViewModel = ProfileViewModel();
            profileViewModel.uploadImageToServer(
                context, File(userPicturePath), (isUploaded) {}, (imageUrl) {
              print("image=== $imageUrl");
              setState(() {

                uploadId = imageUrl;

              });

            },
                requestType: "qr_scan",
                isReturnPath: false,
                showUploadAlertMsg: false);
          }

        }
      } _progressDialog?.hideOpenDialog();
    });
  }


  Future<void> scanAttendanceCode() async {

    cameraController.dispose();
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

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AiBarcodeScanner(
            onScan: (String value) {
              print("barcode text recevied: $value");
              uploadId = "${DateTime.now().millisecondsSinceEpoch}";
              _progressDialog?.showLoadingDialog();
              attendanceViewModel.markAttendanceRequest(
                  value, widget.attendanceType!, uploadId);
            },
          ),
        ),
      );

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
    cameraController = CameraController(cameras[1], ResolutionPreset.high);
    cameraValue = cameraController.initialize();
    attendanceViewModel = AttendanceViewModel();
   // attendanceViewModel.takeUserPictureWithoutPreview();
    attendanceViewModel.addListener(() {
      _progressDialog?.hideOpenDialog();

      userPicturePath = attendanceViewModel.userPicturePath;
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
          Controller()
              .showToastMessage(context, "Request submitted successfully");
          Navigator.pop(context);
          Get.back();
          // Get.to(() => const AttendanceReport());
        } else {
          _errorMsg = attendanceViewModel.getErrorMsg();
          if (_errorMsg?.isNotEmpty == true) {
            if (_errorMsg!.contains(ConstantData.unauthenticatedMsg)) {
              Controller().logoutUser();
            } else {
              Controller().showToastMessage(context, _errorMsg!);
            }
          }
        }
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cameraController.dispose();
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
      floatingActionButton: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SizedBox(
            height: 60.0,
            width: double.infinity,
            child: FloatingActionButton.extended(
              onPressed: () {
                uploadId.isEmpty?
                startCamera() :
                scanAttendanceCode();
              },
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              backgroundColor: primaryColor,
              label:  Text(
                uploadId.isEmpty? "Capture":
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
        body: Stack(
        children: [
          uploadId.isEmpty?
          FutureBuilder(
              future: cameraValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: CameraPreview(cameraController));
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })
              :Center(),
          // uploadId.isEmpty?    Center(
          //   child: Positioned(
          //       child:
          //       Container(
          //         height: 500,
          //        width: 500,
          //
          //         decoration: BoxDecoration(
          //           border: Border.all( //<-- SEE HERE
          //             width: 500,
          //           ),
          //         ),
          //
          //       )
          //   ),
          // ):Center(),
          Positioned(
            top:20,right: 0,left: 0,
            child:  Column(
              children: [
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
                  'Please give access to your Camera so that we can scan and provide you what is inside the code',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1.4,
                    color: colorText,
                  ),
                ),
              ),
              ],
            ),),
        ],
      )
    );
  }
}

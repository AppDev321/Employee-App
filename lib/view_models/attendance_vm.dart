import 'package:camera/camera.dart';
import 'package:hnh_flutter/view_models/base_view_model.dart';
import 'package:hnh_flutter/webservices/APIWebServices.dart';

class AttendanceViewModel extends BaseViewModel {
  String userPicturePath = "";
  bool requestStatus = false;

  bool getRequestStatus() => requestStatus;

  setAttendanceRequestStatus(bool error) async {
    requestStatus = error;
  }

  takeUserPictureWithoutPreview() async {
    final camera = (await availableCameras())[1];
    final controller = CameraController(camera, ResolutionPreset.low);
    try {
      await controller.initialize();
      await controller.setFlashMode(FlashMode.off);
      final image = await controller.takePicture();

      userPicturePath = image.path;
    } catch (e) {
      // print(e);
      await controller.dispose();
    }
    await controller.dispose();

    notifyListeners();
  }

  Future<void> markAttendanceRequest(
      String code, int attendanceType, String uploadID) async {
    setLoading(true);
    //0- check in , 1- check out
    final results = attendanceType == 0
        ? await APIWebService().markAttendance(code, uploadID)
        : await APIWebService().markClockOutAttendance(code, uploadID);

    if (results == null) {
      var errorString = "Check your internet connection";
      setErrorMsg(errorString);
      setAttendanceRequestStatus(false);
      // setIsErrorReceived(true);
    } else {
      if (results.code == 200) {
        setAttendanceRequestStatus(true);
        // setIsErrorReceived(false);
      } else {
        var errorString = "";
        for (int i = 0; i < results.errors!.length; i++) {
          errorString += "${results.errors![i].message!}\n";
        }
        setErrorMsg(errorString);
        setAttendanceRequestStatus(false);
        //  setIsErrorReceived(true);
      }
    }

    setResponseStatus(true);
    setLoading(false);
    notifyListeners();
  }

  Future<void> verifyVehicleTab(String code, String uploadID) async {
    setLoading(true);
    final results = await APIWebService().validateVehicleTab(code, uploadID);

    if (results == null) {
      var errorString = "Check your internet connection";
      setErrorMsg(errorString);
      setAttendanceRequestStatus(false);
      // setIsErrorReceived(true);
    } else {
      if (results.code == 200) {
        setAttendanceRequestStatus(true);
        // setIsErrorReceived(false);
      } else {
        var errorString = "";
        for (int i = 0; i < results.errors!.length; i++) {
          errorString += "${results.errors![i].message!}\n";
        }
        setErrorMsg(errorString);
        setAttendanceRequestStatus(false);
        //  setIsErrorReceived(true);
      }
    }

    setResponseStatus(true);
    setLoading(false);
    notifyListeners();
  }
}

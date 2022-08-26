
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hnh_flutter/repository/model/request/change_password_request.dart';
import 'package:hnh_flutter/view_models/base_view_model.dart';
import 'package:hnh_flutter/webservices/APIWebServices.dart';
import 'package:image_picker/image_picker.dart';
import '../repository/model/response/user_profile.dart';
import '../utils/controller.dart';
import '../widget/custom_text_widget.dart';


import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
class ProfileViewModel extends BaseViewModel {

   Profile profileDetail = Profile();
  setUserProfile(Profile data)
  {
    profileDetail = data;
  }
  getUserProfile() => profileDetail;

   bool isProfileUpdate = false;
   bool getProileUpdateStatus() => isProfileUpdate;

   setProfileStatus(bool error) async {
     isProfileUpdate = error;

   }



  Future<void> changePasswordRequest(ChangePasswordRequest request) async {
    setLoading(true);
    final results = await APIWebService().changePasswordRequest(request);

    if (results == null) {
      var errorString = "Check your internet connection";
      setErrorMsg(errorString);
      setIsErrorReceived(true);
    } else {
      if (results.code == 200) {

        setIsErrorReceived(false);
      } else {
        var errorString = "";
        for (int i = 0; i < results.errors!.length; i++) {
          errorString += results.errors![i].message! + "\n";
        }
        setErrorMsg(errorString);
        setIsErrorReceived(true);
      }
    }

    setResponseStatus(true);
    setLoading(false);
    notifyListeners();
  }



  Future<void> getProfileDetail() async {
    setLoading(true);
    final results = await APIWebService().getUserProfileDetails();

    if (results == null) {
      var errorString = "Check your internet connection";
      setErrorMsg(errorString);
      setIsErrorReceived(true);
    } else {
      if (results.code == 200) {
        setUserProfile(results.data!.profile!);
        setIsErrorReceived(false);
      } else {
        var errorString = "";
        for (int i = 0; i < results.errors!.length; i++) {
          errorString += results.errors![i].message! + "\n";
        }
        setErrorMsg(errorString);
        setIsErrorReceived(true);
      }
    }

    setResponseStatus(true);
    setLoading(false);
    notifyListeners();
  }


  Future<void> updateUserProfile(Profile request) async {
    setLoading(true);
    final results = await APIWebService().updateUserProfileDetail(request);

    if (results == null) {
      setProfileStatus(false);
      var errorString = "Check your internet connection";
      setErrorMsg(errorString);
   //   setIsErrorReceived(true);
    } else {
      if (results.code == 200) {
        setProfileStatus(true);
      //  setIsErrorReceived(false);
      } else {
        var errorString = "";
        for (int i = 0; i < results.errors!.length; i++) {
          errorString += results.errors![i].message! + "\n";
        }
        setErrorMsg(errorString);
       // setIsErrorReceived(true);
        setProfileStatus(false);
      }
    }

    setResponseStatus(true);
    setLoading(false);
    notifyListeners();
  }

   void showPicker(context,ValueChanged<File> imageFile) {
     showModalBottomSheet(
         context: context,
         backgroundColor: Colors.white,
         // set this when inner content overflows, making RoundedRectangleBorder not working as expected
         clipBehavior: Clip.antiAlias,
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
         ),

         builder: (BuildContext bc) {
           return SafeArea(
             child: Container(
               color: Colors.white12,
               child: new Wrap(
                 children: <Widget>[
                   new ListTile(
                       leading: new Icon(Icons.photo_library),
                       title:  CustomTextWidget(text:'Gallery'),
                       onTap: () {
                         pickImageFile(ImageSource.gallery,(value){
                           imageFile(value);
                         });
                         Navigator.of(context).pop();
                       }),
                   new ListTile(
                     leading: new Icon(Icons.photo_camera),
                     title:  CustomTextWidget(text:'Camera'),
                     onTap: () {
                   pickImageFile(ImageSource.camera,(value){
                        imageFile(value);
                    }
                        );

                       Navigator.of(context).pop();


                     },
                   ),
                 ],
               ),
             ),
           );
         }
     );
   }

   pickImageFile(ImageSource type,ValueChanged<File> imageFiles) async {

     final XFile? pickedImage =  await ImagePicker().pickImage(source: type);

     if (pickedImage != null) {

         File imageFile = File(pickedImage.path);

         imageFiles(imageFile);


     }
   }


   uploadProfileImage(File imageFile,ValueChanged<bool> isUpload) async {
     // open a bytestream
     var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
     // get file length
     var length = await imageFile.length();
     // string to uri
     var uri = Uri.parse("http://vmi808920.contaboserver.net/api/upload");

     Controller controller = Controller();
     String? userToken = await controller.getAuthToken();

     var request = new http.MultipartRequest("POST", uri);
     request.headers['Authorization'] = "Bearer $userToken";

     var multipartFile = new http.MultipartFile('file', stream, length,  filename: basename(imageFile.path));

     request.files.add(multipartFile);
      request.fields['type']="profile";
     request.fields['filetype']="image/jpg";
     request.fields['field_name']="profile";
     request.fields['upload_id']="53346765475";

     print(request.fields.toString());

     var response = await request.send();

     print("reponse=${response.statusCode}");
     response.stream.transform(utf8.decoder).listen((value) {
       print("value=${value}");

       isUpload(true);

     });
   }

}

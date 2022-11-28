
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:hnh_flutter/repository/model/request/change_password_request.dart';
import 'package:hnh_flutter/view_models/base_view_model.dart';
import 'package:hnh_flutter/webservices/APIWebServices.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../custom_style/colors.dart';
import '../repository/model/response/user_profile.dart';
import '../utils/controller.dart';
import '../widget/custom_text_widget.dart';
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
   String userProfileImage="";

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
          errorString += "${results.errors![i].message!}\n";
        }
        setErrorMsg(errorString);
        setIsErrorReceived(true);
      }
    }

    setResponseStatus(true);
    setLoading(false);
    notifyListeners();
  }

Future<void> getUserImageURLPreferecne() async{
  userProfileImage = await Controller().getUserProfilePic();
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
          errorString += "${results.errors![i].message!}\n";
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
          errorString += "${results.errors![i].message!}\n";
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
         backgroundColor: cardThemeBaseColor,
         // set this when inner content overflows, making RoundedRectangleBorder not working as expected
         clipBehavior: Clip.antiAlias,
         shape: const RoundedRectangleBorder(
           borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
         ),

         builder: (BuildContext bc) {
           return SafeArea(
             child: Container(
               color: Colors.white12,
               child: Wrap(
                 children: <Widget>[
                   ListTile(
                       leading: const Icon(Icons.photo_library),
                       title:  const CustomTextWidget(text:'Gallery'),
                       onTap: () {
                         pickImageFile(ImageSource.gallery,(value){
                           imageFile(value);
                         });
                         Navigator.of(context).pop();
                       }),
                   ListTile(
                     leading: const Icon(Icons.photo_camera),
                     title:  const CustomTextWidget(text:'Camera'),
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

     final XFile? pickedImage =  await ImagePicker().pickImage(source: type,imageQuality: 60);

     if (pickedImage != null) {
         File imageFile = File(pickedImage.path);
         imageFiles(imageFile);

     }
   }

   uploadImageToServer(
       BuildContext context,
       File imageFile,
       ValueChanged<bool> isUpload,
       ValueChanged<String> imageURL,
       {
         String requestType = "profile",
         bool isReturnPath = true,
         bool showUploadAlertMsg = true
       }

  ) async {

     var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
     var length = await imageFile.length();
     var uri = Uri.parse("${Controller.appBaseURL}/upload");
     Controller controller = Controller();
     String? userToken = await controller.getAuthToken();
     var request = http.MultipartRequest("POST", uri);
     request.headers['Authorization'] = "Bearer $userToken";
     request.headers['Content-Type']="application/json";
     request.headers['Accept']="application/json";
     var multipartFile = http.MultipartFile('file', stream, length,  filename: basename(imageFile.path));
     request.files.add(multipartFile);
     request.fields['type']=requestType;
     request.fields['filetype']="image/jpg";
     request.fields['field_name']=requestType;
     request.fields['upload_id']="${DateTime.now().millisecondsSinceEpoch}";
     print(request.fields.toString());
     var response = await request.send();
     response.stream.transform(utf8.decoder).listen((value) {
       print("response = $value");
       final parsedJson = jsonDecode(value);
       print("parsedJson = $parsedJson");
       isUpload(true);
       if(parsedJson['code'].toString()=="200")
         {
           var data =parsedJson['data'];
           if(data != null){
             var convertedURL = data['complete_url'];
             if(isReturnPath)
               {
                 imageURL(convertedURL) ;
               }
             else
               {
                 imageURL(request.fields['upload_id']!);
               }
           }
         }
       else {

         if (showUploadAlertMsg == true) {
           var error = parsedJson['errors'][0]['message'];
           if (error != null) {
             Controller().showToastMessage(context, error);
           } else {
             Controller().showToastMessage(context,
                 "There is some issue in uploading please try again later");
           }
         }
       }
     });
   }
}

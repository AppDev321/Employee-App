import 'package:camera/camera.dart';
import 'package:hnh_flutter/view_models/base_view_model.dart';
import 'package:hnh_flutter/webservices/APIWebServices.dart';

import '../custom_style/strings.dart';
import '../repository/model/response/contact_list.dart';
import '../utils/controller.dart';

class ChatViewModel extends BaseViewModel {

  List<User> listUser = [];



  Future<void> getContactList() async {
    setLoading(true);
 final results=await APIWebService().getContactList();
    if (results == null) {
      var errorString = "Check your internet connection";
      setErrorMsg(errorString);

   setIsErrorReceived(true);
    } else {
      if (results.code == 200) {
        listUser = results.data!.contacts!;



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

}



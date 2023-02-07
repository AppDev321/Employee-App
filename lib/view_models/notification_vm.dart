import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hnh_flutter/pages/shift/claimed_shift_list.dart';
import 'package:hnh_flutter/repository/model/request/availability_request.dart';
import 'package:hnh_flutter/repository/model/request/claim_shift_request.dart';
import 'package:hnh_flutter/repository/model/request/leave_save_request.dart';
import 'package:hnh_flutter/repository/model/request/overtime_save_request.dart';
import 'package:hnh_flutter/repository/model/response/get_shift_list.dart';
import 'package:hnh_flutter/repository/model/response/vehicle_list_response.dart';
import 'package:hnh_flutter/view_models/base_view_model.dart';
import 'package:hnh_flutter/webservices/APIWebServices.dart';
import 'package:intl/intl.dart';

import '../notification/firebase_notification.dart';
import '../repository/model/request/claim_shift_history_request.dart';
import '../repository/model/response/claimed_shift_list.dart';
import '../repository/model/response/get_dashboard.dart';
import '../repository/model/response/get_notification.dart';
import '../repository/model/response/leave_list.dart';
import '../repository/model/response/overtime_list.dart';

class NotificationViewModel extends BaseViewModel {
  List<NotificationData>? notifications=[];

  Future<void> getNotification() async {
    setLoading(true);
    final results = await APIWebService().getNotification();
    if (results == null) {
      var errorString = "Check your internet connection";
      setErrorMsg(errorString);
    } else {
      if (results.code == 200) {
        setIsErrorReceived(false);
        if(results.data!.notifications!.isNotEmpty)
        {
          notifications = results.data!.notifications!;
        }
        else
        {
          setIsErrorReceived(true);
          notifications=[];
          setErrorMsg("No Notification Found");
        }
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

  Future<void> updateNotificationStatus(String id) async {
    setLoading(true);
    final results = await APIWebService().updateNotificationStatus(id);

    if (results == null) {
      var errorString = "Check your internet connection";
      setErrorMsg(errorString);
    } else {
      if (results.code == 200) {
        setIsErrorReceived(false);
      } else {
        var errorString = "";
        for (int i = 0; i < results.errors!.length; i++) {
          errorString += results.errors![i].message! + "\n";
        }
        setErrorMsg(errorString);
        //setIsErrorReceived(true);
      }
    }
    setResponseStatus(true);
    setLoading(false);
    notifyListeners();
  }


  Future<void> deleteNotificationStatus(String id) async {
    setLoading(true);
    final results = await APIWebService().deleteNotification(id);
    if (results == null) {
      var errorString = "Check your internet connection";
      setErrorMsg(errorString);
    } else {
      if (results.code == 200) {
        setIsErrorReceived(false);
      } else {
        var errorString = "";
        for (int i = 0; i < results.errors!.length; i++) {
          errorString += results.errors![i].message! + "\n";
        }
        setErrorMsg(errorString);
        //setIsErrorReceived(true);
      }
    }
    setResponseStatus(true);
    setLoading(false);
    notifyListeners();
  }



}

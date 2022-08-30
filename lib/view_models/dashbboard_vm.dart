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
import '../repository/model/response/leave_list.dart';
import '../repository/model/response/overtime_list.dart';

class DashBoardViewModel extends BaseViewModel {

  Shifts? dashBoardShift = null;
  Shifts? getDashBoardShift() => dashBoardShift;

  Stats? dashboardStat = null;
  Stats? getDashboardStat() => dashboardStat;


  User? userObject = null;
  User? getUserObject() => userObject;


  final List<DropMenuItems> leaveTypes = [

    DropMenuItems(id:1,name:"Holiday"),
    DropMenuItems(id:2,name:"Sickness"),
    DropMenuItems(id:3,name:"Public Holiday"),
    DropMenuItems(id:4,name:"Absence Authorized"),

    DropMenuItems(id:5,name:"Absence Unauthorized"),
    DropMenuItems(id:6,name:"Compassionate"),
    DropMenuItems(id:7,name:"Maternity / Paternity"),
    DropMenuItems(id:8,name:"Parental"),

    DropMenuItems(id:9,name:"Study Leave"),
    DropMenuItems(id:10,name:"Training"),
    DropMenuItems(id:11,name:"Furlough"),
  ];

  int notificationCount = 0;



  Future<void> getDashBoardData() async {
    setLoading(true);
    final results = await APIWebService().getDashBoardData();

    if (results == null) {
      var errorString = "Check your internet connection";
      setErrorMsg(errorString);


    } else {
      if (results.code == 200) {
        dashBoardShift = results.data?.shift;
        dashboardStat = results.data?.stats;
        userObject = results.data?.user;

       // setIsErrorReceived(false);
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

    getNotificationCount();
  }



  Future<void> getNotificationCount() async {
    setLoading(true);
    final results = await APIWebService().getNotificationCount();

    if (results == null) {
      var errorString = "Check your internet connection";
      setErrorMsg(errorString);
    } else {
      if (results.code == 200) {
        setIsErrorReceived(false);
        notificationCount = results.data!.count;
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



//Notificaiton

  Future<void> getBackgroundFCMNotificaiton() async
  {
    //Check is FCM has Screen Name
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) async {
      print("DashBoardFirebase");
      var screenName = message!.data['activity'];
      if (screenName != null) {
        if(!screenName.toString().toLowerCase().contains("dashboard"))
          LocalNotificationService().navigateFCMScreen(screenName);
      }
    });
    //*************************************
  }

  void firebaseMessaging(BuildContext context) {

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {

        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data['title']}");
          print("message.data22 ${message.data['body']}");
        }

        LocalNotificationService.createandDisplayNotification(message);
      }
    });



    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title!),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body!)],
                  ),
                ),
              );
            });
      }
    });
  }


}

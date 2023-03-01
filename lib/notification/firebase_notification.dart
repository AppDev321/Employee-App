import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hnh_flutter/pages/availability/availability_listing.dart';
import 'package:hnh_flutter/pages/dashboard/dashboard.dart';
import 'package:hnh_flutter/pages/leave/leave_listing.dart';
import 'package:hnh_flutter/pages/overtime/overtime_list.dart';
import 'package:hnh_flutter/pages/shift/shift_list.dart';
import '../utils/controller.dart';

class LocalNotificationService
{
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();


  static void initializeNotification() {
    // initializationSettings  for Android
    const InitializationSettings initializationSettings =
    InitializationSettings( android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    );

    _notificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? screenName) async {
        Controller().printLogs("FlutterLocalNotificationsPlugin == ${screenName}");

        LocalNotificationService().navigateFCMScreen(screenName);

      },
    );
  }



   void navigateFCMScreen(String? screenName)
   {
     if(screenName != null)
     {
       var screens = screenName.toLowerCase();
       if(screens.contains(Screen.SHIFT.displayTitle.toLowerCase()))
       {
         //  Get.offAll(()=>Dashboard()); //to remove all activities from bback stack
         Get.to(()=>ShiftList());
       }
       else if (screens.contains(Screen.LEAVE.displayTitle.toLowerCase()))
       {
         Get.to(()=>LeavePage());
       }
       else if(screens.contains(Screen.OVERTIME.displayTitle.toLowerCase()))
       {
         Get.to(()=>OverTimePage());

       }
       else if(screens.contains(Screen.AVAILABILITY.displayTitle.toLowerCase()))
       {
         Get.to(()=>AvailabilityList());

       }
       else if(screens.contains(Screen.DASHBOARD.displayTitle.toLowerCase()))
       {
         Get.to(()=>Dashboard());

       }


     }
   }




  static void createandDisplayNotification(RemoteMessage message) async {
    try {
      initializeNotification();
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "pushnotificationapp",
          "pushnotificationappchannel",
          importance: Importance.max,
          priority: Priority.high,
        ),
      );

      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: message.data['activity'],

      );
    } on Exception catch (e) {
      Controller().printLogs("${e}");
    }
  }


  static void customNotification(int notificationID,{String? message="A new message arrived",String? title="AFJ Message"}) async {
    try {
      initializeNotification();
      final id =notificationID ;//DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "pushnotificationapp",
          "pushnotificationappchannel",
          importance: Importance.max,
          priority: Priority.high,
        ),
      );

      await _notificationsPlugin.show(
        id,
        title,
        message,
        notificationDetails,

      );
    } on Exception catch (e) {
      Controller().printLogs("${e}");
    }
  }

}
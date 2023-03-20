import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hnh_flutter/pages/availability/availability_listing.dart';
import 'package:hnh_flutter/pages/dashboard/dashboard.dart';
import 'package:hnh_flutter/pages/leave/leave_listing.dart';
import 'package:hnh_flutter/pages/overtime/overtime_list.dart';
import 'package:hnh_flutter/pages/shift/shift_list.dart';
import '../utils/controller.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();






  static Future<void> initializeNotification() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    const IOSInitializationSettings iOSInitializationSettings =
        IOSInitializationSettings(
      requestSoundPermission: true,
      requestAlertPermission: true,
      requestBadgePermission: true,
    );
    const InitializationSettings settings = InitializationSettings(
        android: androidInitializationSettings, iOS: iOSInitializationSettings);
    await _notificationsPlugin.initialize(
      settings,
      onSelectNotification: (String? screenName) async {
        Controller()
            .printLogs("FlutterLocalNotificationsPlugin == ${screenName}");
        LocalNotificationService().navigateFCMScreen(screenName);
      },
    );
  }



  static Future<NotificationDetails> notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('channelId', 'channelName',
        channelDescription: 'description',
        importance: Importance.max,
        priority: Priority.max,
        playSound: true);
    const IOSNotificationDetails iosNotificationDetails =
    IOSNotificationDetails();

    return const NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);
  }


  void navigateFCMScreen(String? screenName) {
    if (screenName != null) {
      var screens = screenName.toLowerCase();
      if (screens.contains(Screen.SHIFT.displayTitle.toLowerCase())) {
        //  Get.offAll(()=>Dashboard()); //to remove all activities from bback stack
        Get.to(() => ShiftList());
      } else if (screens.contains(Screen.LEAVE.displayTitle.toLowerCase())) {
        Get.to(() => LeavePage());
      } else if (screens.contains(Screen.OVERTIME.displayTitle.toLowerCase())) {
        Get.to(() => OverTimePage());
      } else if (screens
          .contains(Screen.AVAILABILITY.displayTitle.toLowerCase())) {
        Get.to(() => AvailabilityList());
      } else if (screens
          .contains(Screen.DASHBOARD.displayTitle.toLowerCase())) {
        Get.to(() => Dashboard());
      }
    }
  }

  static void createandDisplayNotification(RemoteMessage message) async {
    try {
      await initializeNotification();
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final details = await notificationDetails();
      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        details,
        payload: message.data['activity'],
      );
    } on Exception catch (e) {
      Controller().printLogs("${e}");
    }
  }

  static void customNotification(int notificationID,
      {String? message = "A new message arrived",
      String? title = "AFJ Message"}) async {
    try {

      await initializeNotification();
      final id = notificationID;
      final details = await notificationDetails();
      await _notificationsPlugin.show(
        id,
        title,
        message,
        details,
      );
    } on Exception catch (e) {
      Controller().printLogs("${e}");
    }
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hnh_flutter/utils/controller.dart';

import '../notification/firebase_notification.dart';

part 'connected_event.dart';
part 'connected_state.dart';

class ConnectedBloc extends Bloc<ConnectedEvent, ConnectedState> {
  StreamSubscription? subscription;

  ConnectedBloc() : super(ConnectedInitialState()) {
    on<OnConnectedEvent>((event, emit) => emit(ConnectedSucessState()));
    on<OnNotConnectedEvent>((event, emit) => emit(ConnectedFailureState()));
    on<OnFirebaseNotificationReceive>((event,emit)=>emit(FirebaseMsgReceived(screenName: event.screenName)));

    subscription = Connectivity()  .onConnectivityChanged  .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) {
        add(OnConnectedEvent());

      } else {
             add(OnNotConnectedEvent());

      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        if (message.notification != null) {
          print("NotificationData=${message.data.toString()}");

          var screenName=message.data['activity'];
          if(screenName != null)
          {
            var screens = screenName.toLowerCase();
            if(screens.contains(Screen.SHIFT.displayTitle.toLowerCase()))
            {
              add(OnFirebaseNotificationReceive(screenName:Screen.SHIFT));
            }
            else if (screens.contains(Screen.LEAVE.displayTitle.toLowerCase()))
            {
              add(OnFirebaseNotificationReceive(screenName:Screen.LEAVE));
            }
            else if (screens.contains(Screen.OVERTIME.displayTitle.toLowerCase()))
            {
              add(OnFirebaseNotificationReceive(screenName:Screen.OVERTIME));
            }
            else if (screens.contains(Screen.AVAILABILITY.displayTitle.toLowerCase()))
            {
              add(OnFirebaseNotificationReceive(screenName:Screen.AVAILABILITY));
            }
            else if (screens.contains(Screen.REPORT.displayTitle.toLowerCase()))
            {
              add(OnFirebaseNotificationReceive(screenName:Screen.REPORT));
            }
            else if (screens.contains(Screen.DASHBOARD.displayTitle.toLowerCase()))
            {
              add(OnFirebaseNotificationReceive(screenName:Screen.DASHBOARD));
            }

            else{
              //nothing
            }

          }
        }

        LocalNotificationService.createandDisplayNotification(message);
      }
    });

  }
  @override
  Future<void> close() {
    subscription?.cancel();
    return super.close();
  }




//Notificaiton
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
      print('BLoc Msg:${message.data.toString()}');
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

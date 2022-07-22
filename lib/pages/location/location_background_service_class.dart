import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator/background_locator.dart';
import 'package:background_locator/location_dto.dart';
import 'package:background_locator/settings/android_settings.dart';
import 'package:background_locator/settings/ios_settings.dart';
import 'package:background_locator/settings/locator_settings.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hnh_flutter/pages/location/location_callback_handler.dart';
import 'package:hnh_flutter/repository/retrofit/api_client.dart';
import 'package:hnh_flutter/utils/controller.dart';

import 'maplocation.dart';
import 'location_callback_handler.dart';
import 'location_service_repository.dart';

class LocationServiceClass {
  ReceivePort port = ReceivePort();

  String logStr = '';
  late bool isRunning;
  late LocationDto? lastLocation;
  late State<MapLocation> statefulWidgetClass;


  void initState(State<MapLocation> statefulWidgetClass) {

    this.statefulWidgetClass = statefulWidgetClass;
    if (IsolateNameServer.lookupPortByName(
            LocationServiceRepository.isolateName) !=
        null) {
      IsolateNameServer.removePortNameMapping(
          LocationServiceRepository.isolateName);
    }

    IsolateNameServer.registerPortWithName(
        port.sendPort, LocationServiceRepository.isolateName);

    port.listen(
      //Update any line of data
      (dynamic data) async {
     //   await updateUI(data);
        await _updateNotificationText(data);

      },
    );
    initPlatformState();
  }

  Future<void> updateUI(LocationDto data) async {
   // final log = await FileManager.readLogFile();
    print('update Ui');
/*    statefulWidgetClass.setState(() {
      if (data != null) {
        lastLocation = data;
      }
      logStr = "Start Data updating";
    });*/
    await _updateNotificationText(data);

  }

  Future<void> _updateNotificationText(LocationDto data) async {
    if (data == null) {
      return;
    }
    print('update notification Ui');

    await BackgroundLocator.updateNotificationText(
        title: "new location received",
        msg: "${DateTime.now()}",
        bigMsg: "${data.latitude}, ${data.longitude}");

    setUpdateLocation(data);
  }



  Future<void> initPlatformState() async {
    print('Initializing...');
    await BackgroundLocator.initialize();
   // logStr = await FileManager.readLogFile();
    print('Initialization done');
    final _isRunning = await BackgroundLocator.isServiceRunning();
    statefulWidgetClass.setState(() {
      isRunning = _isRunning;
    });
    print('Running ${isRunning.toString()}');
  }

  Future<void> onStopService() async {
    await BackgroundLocator.unRegisterLocationUpdate();
    final _isRunning = await BackgroundLocator.isServiceRunning();
    statefulWidgetClass.setState(() {
      isRunning = _isRunning;
    });
  }

  Future<void> onStartService() async {
    await _startLocator();
    final _isRunning = await BackgroundLocator.isServiceRunning();

    statefulWidgetClass.setState(() {
      isRunning = _isRunning;
      lastLocation = null;
    });
  }

  Future<bool> checkCheckService() async {
    return isRunning;
  }


  Future<void> _startLocator() async {
    Map<String, dynamic> data = {'countInit': 1};
    return await BackgroundLocator.registerLocationUpdate(
        LocationCallbackHandler.callback,
        initCallback: LocationCallbackHandler.initCallback,
        initDataCallback: data,
        disposeCallback: LocationCallbackHandler.disposeCallback,
        iosSettings: IOSSettings(
            accuracy: LocationAccuracy.NAVIGATION, distanceFilter: 0),
        autoStop: false,
        androidSettings: AndroidSettings(
            accuracy: LocationAccuracy.NAVIGATION,
            interval: 20,
            distanceFilter: 0,
            client: LocationClient.google,
            androidNotificationSettings: AndroidNotificationSettings(
                notificationChannelName: 'Location tracking',
                notificationTitle: 'Start Location Tracking',
                notificationMsg: 'Track location in background',
                notificationBigMsg:
                    'Background location is on to keep the app up-tp-date with your location. This is required for main features to work properly when the app is not running.',
                notificationIconColor: Colors.grey,
                notificationTapCallback:
                    LocationCallbackHandler.notificationCallback)));
  }




  Future setUpdateLocation(LocationDto loc) async{
    Controller controller =  Controller();
    String? authToken = await controller.getAuthToken();
   // print("authenticaiton Token " + authToken.toString());
    updateLocationApi(loc,authToken.toString());
  }



  FutureBuilder<void> updateLocationApi(LocationDto data, String? userToken) {
    print('token=$userToken');
    final client = ApiClient(Dio(BaseOptions(
        contentType: "application/json",
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userToken}',
          'Accept': 'application/json'
        }
    )
    )
    );
    return FutureBuilder<void>(
      future: client.updateLocation(data),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return Center();
          } else {
            return Center(
            );
          }
        } else {
          return Center();
        }
      },
    );
  }




}

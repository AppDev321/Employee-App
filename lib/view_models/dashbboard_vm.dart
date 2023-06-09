import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:get/get.dart';
import 'package:hnh_flutter/database/dao/call_history_dao.dart';
import 'package:hnh_flutter/database/model/call_history_table.dart';
import 'package:hnh_flutter/pages/videocall/audio_call_screen.dart';
import 'package:hnh_flutter/repository/model/response/get_shift_list.dart';
import 'package:hnh_flutter/repository/model/response/report_attendance_response.dart';
import 'package:hnh_flutter/view_models/base_view_model.dart';
import 'package:hnh_flutter/view_models/chat_vm.dart';
import 'package:hnh_flutter/webservices/APIWebServices.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../database/database_single_instance.dart';
import '../notification/firebase_notification.dart';
import '../pages/videocall/video_call_screen.dart';
import '../repository/model/request/socket_message_model.dart';
import '../repository/model/response/events_list.dart';
import '../repository/model/response/get_dashboard.dart';
import '../repository/model/response/leave_list.dart';
import '../utils/controller.dart';

class DashBoardViewModel extends BaseViewModel {
  Shifts? dashBoardShift = null;

  Shifts? getDashBoardShift() => dashBoardShift;

  Stats? dashboardStat = null;

  Stats? getDashboardStat() => dashboardStat;

  List<Events> events = [];

  List<Events> getEventsList() => events;
  Attendance? attendance = null;

  User userObject = User();

  User getUserObject() => userObject;
  bool isCheckInOut = false;
  bool videoCallStatus = false;

  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  final List<DropMenuItems> leaveTypes = [
    DropMenuItems(id: 1, name: "Holiday"),
    DropMenuItems(id: 2, name: "Sickness"),
    DropMenuItems(id: 3, name: "Public Holiday"),
    DropMenuItems(id: 4, name: "Absence Authorized"),
    DropMenuItems(id: 5, name: "Absence Unauthorized"),
    DropMenuItems(id: 6, name: "Compassionate"),
    DropMenuItems(id: 7, name: "Maternity / Paternity"),
    DropMenuItems(id: 8, name: "Parental"),
    DropMenuItems(id: 9, name: "Study Leave"),
    DropMenuItems(id: 10, name: "Training"),
    DropMenuItems(id: 11, name: "Furlough"),
  ];

  int notificationCount = 0;

  //Future<AppDatabase?> get afjDatabase async => await AFJDatabaseInstance.instance.afjDatabase;

  void insertCallDetailInDB(
      SocketMessageModel socketMessageModel, bool isMissed) async {
    var now = DateTime.now();
    final db = await AFJDatabaseInstance.instance.afjDatabase;
    final callHisoryDAO = db?.callHistoryDAO as CallHistoryDAO;

    var data = CallHistoryTable(
        socketMessageModel.sendFrom.toString(),
        "",
        socketMessageModel.callerName.toString(),
        socketMessageModel.callType.toString(),
        true,
        isMissed,
        Controller().getConvertedDate(now),
        Controller().getConvertedTime(now),
        "",
        "0");
    await callHisoryDAO.insertCallHistoryRecord(data);
  }

  void insertMessageDetailInDB(
      SocketMessageModel socketMessageModel, bool isMissed) async {
    var now = DateTime.now();
    final db = await AFJDatabaseInstance.instance.afjDatabase;
    final callHisoryDAO = db?.callHistoryDAO as CallHistoryDAO;

    var data = CallHistoryTable(
        socketMessageModel.sendFrom.toString(),
        "",
        socketMessageModel.callerName.toString(),
        socketMessageModel.callType.toString(),
        true,
        isMissed,
        Controller().getConvertedDate(now),
        Controller().getConvertedTime(now),
        "",
        "0");
    await callHisoryDAO.insertCallHistoryRecord(data);
  }

  Future<void> getDashBoardData() async {
    setLoading(true);

    final results = await APIWebService().getDashBoardData();

    if (results == null) {
      var errorString = "Check your internet connection";
      setErrorMsg(errorString);
    } else {
      if (results.code == 200) {
        isCheckInOut = false;
        dashBoardShift = results.data?.shift;
        dashboardStat = results.data?.stats;
        userObject = results.data!.user!;
        videoCallStatus = results.data!.isChatEnabled!;

        attendance = results.data?.attendance;
        if (results.data!.checkedIn == false &&
            results.data?.attendance != null) {
          isCheckInOut = true;
        }

        // setIsErrorReceived(false);
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

    getNotificationCount();

    getEventsListResponse();
    //Get Contact list and stored in database
    ChatViewModel chatViewModel = ChatViewModel();
    chatViewModel.getContactList();
    //*********************
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

  Future<void> getBackgroundFCMNotificaiton() async {
    //Check is FCM has Screen Name
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) async {
      var screenName = message?.data['activity'];
      if (screenName != null) {
        if (!screenName.toString().toLowerCase().contains("dashboard"))
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
          Controller().printLogs("${message.notification!.title}");
          Controller().printLogs("${message.notification!.body!}");
          Controller().printLogs("message.data22 ${message.data['title']}");
          Controller().printLogs("message.data22 ${message.data['body']}");
        }

        LocalNotificationService.createandDisplayNotification(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Controller().printLogs('A new onMessageOpenedApp event was published!');
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

  Future<void> initFireBaseConfig() async {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 30),
      minimumFetchInterval: const Duration(seconds: 120),
    ));
    fetchConfig();
  }

  void fetchConfig() async {
    await remoteConfig.fetchAndActivate();
    if(kDebugMode==false) {
      var baseURL = remoteConfig.getString("API_BASE_URL");
      Controller().printLogs("BASE_URL_Firebase = $baseURL");
      Controller.appBaseURL = baseURL;
    }
      }

  Future<String> getWebSocketURL() async {
    var webSocketURL = remoteConfig.getString("WEB_SOCKET_CALL_URL");
    if(kDebugMode==false) {

      Controller.webSocketURL = webSocketURL;
    }
    else
      {
        webSocketURL = Controller.webSocketURL;
      }
    return webSocketURL;
  }

  Future<void> getAppVersionCheck(ValueChanged<String> updateFound) async {
    final results = await APIWebService().getAppVersion();
    if (results != null) {
      if (results.code == 200) {
        var data = results.data?.appData as List<AppData>;
        for (int i = 0; i < data.length; i++) {
          var item = data[i];
          if (item.appName.toString().toUpperCase() == "EMPLOYEE") {
            PackageInfo packageInfo = await PackageInfo.fromPlatform();
            String version = packageInfo.version;
            //String code = packageInfo.buildNumber;
            if (item.version != version) {
              updateFound(item.downloadUrl.toString());
            }
          }
        }

        setIsErrorReceived(false);
      }
    }
  }

  showVersionDialog(context, String url) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "New Update Available";
        String message =
            "There is a newer version of app available please update it now.";
        String btnLabel = "Update Now";
        String btnLabelCancel = "Close";
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              ElevatedButton(
                child: Text(btnLabel),
                onPressed: () async {
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url));
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ),
              ElevatedButton(
                child: Text(btnLabelCancel),
                onPressed: () => exit(0),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> getEventsListResponse() async {
    setLoading(true);

    final results = await APIWebService().getEventsList();

    if (results == null) {
      var errorString = "Check your internet connection";
      setErrorMsg(errorString);
      setIsErrorReceived(true);
    } else {
      if (results.code == 200) {
        events = results.data!.events!;

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

  //handle socketMessages
  void handleSocketMessage(SocketMessageType type, SocketMessageModel message) {
    switch (type) {
      case SocketMessageType.IncomingCall:
        makeIncomingCall(message);
        break;
      case SocketMessageType.CallAlreadyAnswer:
        FlutterCallkitIncoming.endAllCalls();
        break;
    }
  }

  void makeIncomingCall(SocketMessageModel message) {
    var uuid = const Uuid();
    final _currentUuid = uuid.v4();
    var params = <String, dynamic>{
      'id': _currentUuid,
      'nameCaller': message.callerName,
      'appName': 'AFJ App',
      'avatar': 'https://i.pravatar.cc/100',
      'handle': 'Incoming Call',
      'type': message.callType.toString().contains("audio") ? 0 : 1,
      'duration': 1000 * 60,
      'textAccept': 'Accept',
      'textDecline': 'Decline',
      'textMissedCall': 'Missed call',
      'textCallback': 'Call back',
      'extra': message.toJson(),
      'headers': <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
      'android': <String, dynamic>{
        'isCustomNotification': true,
        'isShowLogo': false,
        'isShowCallback': true,
        'isShowMissedCallNotification': true,
        'ringtonePath': 'system_ringtone_default',
        'backgroundColor': '#0955fa',
        'backgroundUrl': '',
        'actionColor': '#4CAF50'
      },
      'ios': <String, dynamic>{
        'iconName': 'CallKitLogo',
        'handleType': '',
        'supportsVideo': true,
        'maximumCallGroups': 2,
        'maximumCallsPerCallGroup': 1,
        'audioSessionMode': 'default',
        'audioSessionActive': true,
        'audioSessionPreferredSampleRate': 44100.0,
        'audioSessionPreferredIOBufferDuration': 0.005,
        'supportsDTMF': true,
        'supportsHolding': true,
        'supportsGrouping': false,
        'supportsUngrouping': false,
        'ringtonePath': 'system_ringtone_default'
      }
    };

    CallKitParams callKitParams = CallKitParams(
      id: _currentUuid,
      nameCaller: message.callerName,
      appName: 'AFJ App',
      avatar: 'https://i.pravatar.cc/100',
      handle: 'Incoming Call',
      type: message.callType.toString().contains("audio") ? 0 : 1,
      textAccept: 'Accept',
      textDecline: 'Decline',
      textMissedCall: 'Missed call',
      textCallback: 'Call back',
      duration: 1000 * 60,
      android: const AndroidParams(
          isCustomNotification: true,
          isShowLogo: false,
          isShowCallback: false,
          isShowMissedCallNotification: true,
          ringtonePath: 'system_ringtone_default',
          backgroundColor: '#0955fa',
          backgroundUrl: 'https://i.pravatar.cc/500',
          actionColor: '#4CAF50',
          incomingCallNotificationChannelName: "Incoming Call",
          missedCallNotificationChannelName: "Missed Call"),
      ios: IOSParams(
        iconName: 'CallKitLogo',
        handleType: 'generic',
        supportsVideo: true,
        maximumCallGroups: 2,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: true,
        supportsHolding: true,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'system_ringtone_default',
      ),
    );

    FlutterCallkitIncoming.showCallkitIncoming(callKitParams);

    listenerEvent((callback) {
      //   Controller().printLogs('HOME: ${event?.body['extra']}');
      switch (callback.event) {
        case Event.ACTION_CALL_ACCEPT:
          message.callType.toString().contains("audio")
              ? Get.to(() => AudioCallScreen(
                    targetUserID: message.sendFrom.toString(),
                    isIncommingCall: true,
                    socketMessageModel: message,
                  ))
              : Get.to(() => VideoCallScreen(
                    targetUserID: message.sendFrom.toString(),
                    isIncommingCall: true,
                    socketMessageModel: message,
                  ));

          insertCallDetailInDB(message, false);

          break;
        case Event.ACTION_CALL_TIMEOUT:
          insertCallDetailInDB(message, true);
          break;
      }
    });
  }

  void listenerEvent(Function? callback) {
    FlutterCallkitIncoming.onEvent.listen((event) {
      switch (event?.event) {
        case Event.ACTION_CALL_INCOMING:
          // TODO: received an incoming call
          break;
        case Event.ACTION_CALL_START:
          // TODO: started an outgoing call
          // TODO: show screen calling in Flutter
          break;
        case Event.ACTION_CALL_ACCEPT:
          if (callback != null) {
            callback(event);
          }
          break;
        case Event.ACTION_CALL_DECLINE:
          if (callback != null) {
            callback(event);
          }

          break;
        case Event.ACTION_CALL_ENDED:
          break;
        case Event.ACTION_CALL_TIMEOUT:
          if (callback != null) {
            callback(event);
          }
          break;
        case Event.ACTION_CALL_CALLBACK:
          // TODO: only Android - click action `Call back` from missed call notification
          break;
        case Event.ACTION_CALL_TOGGLE_HOLD:
          // TODO: only iOS
          break;
        case Event.ACTION_CALL_TOGGLE_MUTE:
          // TODO: only iOS
          break;
        case Event.ACTION_CALL_TOGGLE_DMTF:
          // TODO: only iOS
          break;
        case Event.ACTION_CALL_TOGGLE_GROUP:
          // TODO: only iOS
          break;
        case Event.ACTION_CALL_TOGGLE_AUDIO_SESSION:
          // TODO: only iOS
          break;
        case Event.ACTION_DID_UPDATE_DEVICE_PUSH_TOKEN_VOIP:
          // TODO: only iOS
          break;
      }
    });
  }
}

class FirebaseAppUpdate {
  List<AppData>? appData;

  FirebaseAppUpdate({this.appData});

  FirebaseAppUpdate.fromJson(Map<String, dynamic> json) {
    if (json['app_data'] != null) {
      appData = <AppData>[];
      json['app_data'].forEach((v) {
        appData!.add(AppData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (appData != null) {
      data['app_data'] = appData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AppData {
  String? appName;
  String? version;
  String? downloadUrl;

  AppData({this.appName, this.version, this.downloadUrl});

  AppData.fromJson(Map<String, dynamic> json) {
    appName = json['app_name'];
    version = json['version'];
    downloadUrl = json['download_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['app_name'] = appName;
    data['version'] = version;
    data['download_url'] = downloadUrl;
    return data;
  }
}

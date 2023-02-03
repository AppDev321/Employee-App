
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:hnh_flutter/repository/model/request/socket_message_model.dart';
import 'package:hnh_flutter/websocket/websocket.dart';

import '../../utils/controller.dart';

class SocketService {
  static SocketService? _instance;
  static BuildContext? buildContext;
  late AFJWebSocket webSocket ;

  SocketService._(String socketUrl) {
    Controller().printLogs("socket URl = $socketUrl");
    webSocket = AFJWebSocket(socketUrl);
    listenWebSocketMessage();
  }

  factory SocketService([String? socketUrl,BuildContext? context ]) {
    _instance ??= SocketService._(socketUrl.toString());
    buildContext = context;
    return _instance!;
  }

  void listenWebSocketMessage(){
    webSocket.listenForMessages((messageData) {

      FBroadcast.instance().broadcast(Controller().socketMessageBroadCast, value: messageData);
    }, onError: (error){
      Controller().printLogs("socket error ${error.toString()}");
      Controller().showToastMessage(buildContext!, "Not able to connect to socket connection\n${error.toString()}");
    });



  }
/*  void listenWebSocketMessage(void Function(SocketMessageModel messageModel) onData, void Function(String msg) onError) {



    webSocket.listenForMessages((messageData) {
        onData(messageData);
    }, onError: onError);
  }*/
  void sendMessageToWebSocket(SocketMessageModel message) {
    webSocket.sendMessage(message);
  }
}

import 'package:fbroadcast/fbroadcast.dart';
import 'package:hnh_flutter/repository/model/request/socket_message_model.dart';
import 'package:hnh_flutter/websocket/websocket.dart';

import '../../utils/controller.dart';

class SocketService {
  static SocketService? _instance;
  late WebSocket webSocket ;

  SocketService._(String socketUrl) {
    print("socket URl = $socketUrl");
    webSocket = WebSocket(socketUrl);
    listenWebSocketMessage();
  }

  factory SocketService([String? socketUrl ]) {
    _instance ??= SocketService._(socketUrl.toString());
    return _instance!;
  }

  void listenWebSocketMessage(){
    webSocket.listenForMessages((messageData) {
      FBroadcast.instance().broadcast(Controller().socketMessageBroadCast, value: messageData);
    }, onError: (error){
      print("socket error ${error.toString()}");
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
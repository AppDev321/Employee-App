
import 'package:hnh_flutter/repository/model/request/socket_message_model.dart';
import 'package:hnh_flutter/websocket/websocket.dart';

class SocketService {

  static final SocketService _singleton = SocketService._internal();
  SocketService._internal();


  late WebSocket webSocket;
  factory SocketService(String socketUrl) {
print("socket URl = $socketUrl");
    _singleton.webSocket = WebSocket(socketUrl);
    return _singleton;
  }




  void listenWebSocketMessage(void Function(SocketMessageModel messageModel) onData, void Function(String msg) onError) {
    webSocket.listenForMessages((messageData) {
        onData(messageData);
    }, onError: onError);
  }
  void sendMessageToWebSocket(SocketMessageModel message) {
    webSocket.sendMessage(message);
  }
}
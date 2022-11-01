
import 'package:hnh_flutter/repository/model/request/socket_message_model.dart';
import 'package:hnh_flutter/websocket/websocket.dart';

class ChatService {
  late WebSocket webSocket;
  ChatService(String serverHostname) {
    webSocket = WebSocket(serverHostname);
  }
  void listenWebSocketMessage() {
    webSocket.listenForMessages();
  }
  void sendMessageToWebSocket(SocketMessageModel message) {
    webSocket.sendMessage(message);
  }
}
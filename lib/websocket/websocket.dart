import 'dart:convert';

import 'package:hnh_flutter/repository/model/request/socket_message_model.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocket {
  late IOWebSocketChannel channel;
  late String webSocketUrl;

  //String webSocket = "ws://192.168.18.69:6001/mobile?token=11";

  WebSocket(this.webSocketUrl) {
    channel = IOWebSocketChannel.connect(webSocketUrl);
  }

  void disconnectFromServer() {
    channel.sink.close(status.goingAway);
  }

  void listenForMessages() {
    channel.stream.listen(
      (event) {
        Map<String, dynamic> mapData = json.decode(event);
        var webSocketServerResponse = SocketMessageModel.fromJson(mapData);
        print('Socket Message Received: ${webSocketServerResponse.toJson()}');
      },
      onDone: () {},
      onError: (err) {
        print("Socket Message parsing issue: $err");
      },
    );
  }

  void sendMessage(SocketMessageModel message) {
    print('Sending Message to Socket: ${jsonEncode(message.toJson())}');
    channel.sink.add(jsonEncode(message.toJson()));
  }
}

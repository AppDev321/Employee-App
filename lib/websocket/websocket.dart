import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:hnh_flutter/repository/model/request/socket_message_model.dart';
import 'package:web_socket_client/web_socket_client.dart';

import '../utils/controller.dart';

class AFJWebSocket {
  late WebSocket channel;
  late String webSocketUrl;
  int retryCount = 0;
  int maxRetrCount = 20;
  int reConnectSeconds = 5;

  AFJWebSocket(this.webSocketUrl) {
    // Create a WebSocket client.
    final uri = Uri.parse(webSocketUrl);
    var backoff = LinearBackoff(
      initial: Duration(seconds: 0),
      increment: Duration(seconds: 1),
      maximum: Duration(seconds: 5),
    );
    channel = WebSocket(uri, backoff: backoff);
  }

  void disconnectFromServer() {
    channel.close(1000, 'CLOSE_NORMAL');
  }

  void listenForMessages(void Function(SocketMessageModel messgeData) onData,
      {required Function(String msg) onError}) {
    channel.messages.listen(
      (event) {
        Map<String, dynamic> mapData = json.decode(event);
        var webSocketServerResponse = SocketMessageModel.fromJson(mapData);

        onData(webSocketServerResponse);
      },
      onDone: () {
        Controller().printLogs("Websocket ONDone called");
      },
      onError: (err) {
        onError(err.toString());
      },
    );


    channel.connection.listen((state) {
      if (state is Connected) {
        Controller().printLogs('SocketConnectionState: Connected');
      } else if (state is Reconnected) {
        Controller().printLogs('SocketConnectionState: Reconnected');
      } else if (state is Disconnected) {
        Controller().printLogs('SocketConnectionState: Disconnected');
      } else if (state is Reconnecting) {
        Controller().printLogs('SocketConnectionState: Reconnecting');
      }
    });
  }

  void sendMessage(SocketMessageModel message) {
    Controller().printLogs('Sending Message to Socket: ${jsonEncode(message.toJson())}');
    channel.send(jsonEncode(message.toJson()));
  }
}

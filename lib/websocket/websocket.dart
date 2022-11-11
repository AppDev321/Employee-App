import 'dart:convert';

import 'package:hnh_flutter/repository/model/request/socket_message_model.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocket {
  late IOWebSocketChannel channel;
  late String webSocketUrl;

  WebSocket(this.webSocketUrl) {
    channel = IOWebSocketChannel.connect(webSocketUrl);
  }

  void disconnectFromServer() {
    channel.sink.close(status.goingAway);
  }

  void listenForMessages(void Function(SocketMessageModel messgeData) onData,
      {required Function(String msg) onError}) {
    channel.stream.listen(
      (event) {

        Map<String, dynamic> mapData = json.decode(event);
        var webSocketServerResponse = SocketMessageModel.fromJson(mapData);

        onData(webSocketServerResponse);
      },
      onDone: () {},
      onError: (err) {
        onError(err.toString());
      },
    );
  }

  void sendMessage(SocketMessageModel message) {
    print('Sending Message to Socket: ${jsonEncode(message.toJson())}');
    channel.sink.add(jsonEncode(message.toJson()));
  }
}

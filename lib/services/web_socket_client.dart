import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:web_socket_channel/io.dart';

class WebSocketClient {
  IOWebSocketChannel? channel;

  late StreamController<Map<String, dynamic>> messageController;

  WebSocketClient() {
    _initializeController();
  }

  void _initializeController() {
    messageController = StreamController<Map<String, dynamic>>.broadcast();
  }

  void connect(String url, Map<String, dynamic> headers) {
    if (channel != null && channel!.closeCode == null) {
      return;
    }

    channel = IOWebSocketChannel.connect(url, headers: headers);

    channel!.stream.listen((event) {
      Map<String, dynamic> message = jsonDecode(event);

      if (message['event'] == 'message.created') {
        messageController.add(message["data"]);
      }
    }, onDone: () {
      log("Connection closed");
      disconnect();
    }, onError: (err) {
      log("Error channel stream $err");
    });
  }

  void send(String data) {
    if (channel == null && channel!.closeCode != null) {
      return;
    }
    channel!.sink.add(data);
  }

  Stream<Map<String, dynamic>> messageUpdate() {
    return messageController.stream;
  }

  void disconnect() {
    if (channel == null || channel!.closeCode == null) {
      return;
    }
    log("DISCONNECT MESSAGE CONTROLLER");
    channel!.sink.close();
    messageController.close();
    _initializeController();
  }
}

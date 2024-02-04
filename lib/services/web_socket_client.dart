import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:chat_app/utils/app_print.dart';
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

      AppPrint.debugPrint("WEB SOCKET MESSAGE $message");

      // final decode = jsonDecode(message["data"] is String
      //     ? message["data"]
      //     : jsonEncode(message["data"])) as Map<String, dynamic>;

      if (message['event'] == 'message.created') {
        messageController.add(message["data"]);
      }

      // if (message['event'] == 'message.received') {
      //   messageController
      //       .add(message["data"] is String ? decode : message['data']);
      // }
    }, onDone: () {
      log("Connection closed");
      disconnect();
    }, onError: (err) {
      disconnect();
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

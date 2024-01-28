import 'dart:convert';

import 'package:api/src/repositories/message_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

Future<Response> onRequest(RequestContext context) async {
  final messageRepository = context.read<MessageRepository>();
  final handler = webSocketHandler((channel, protocol) {
    channel.stream.listen((message) {
      if (message is! String) {
        channel.sink.add('Invalid message');
        return;
      }
      Map<String, dynamic> messageJson = jsonDecode(message);
      final event = messageJson["event"];
      final data = messageJson["data"];
      print('event: ${event} data: $data');

      switch (event) {
        case 'message.create':
          // messageRepository
          //     .createMessage(jsonDecode(jsonEncode(data)))
          //     .then((message) {
          //   print("CREATE MESSAGE $message");
          //   channel.sink.add(jsonEncode({
          //     'event': 'message.created',
          //     'message': data,
          //   }));
          // }).catchError((e) {
          //   print('ERROR ON REQUEST WS $e');
          // });
          break;
        default:
      }
    });
  });
  return handler(context);
}

import 'dart:convert';

import 'package:api/src/repositories/message_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

Future<Response> onRequest(RequestContext context) async {
  final messageRepository = context.read<MessageRepository>();
  final handler = webSocketHandler((channel, protocol) {
    channel.stream.listen((message) {
      if (message is! String) {
        channel.sink.add("Invalid message!");
        return;
      }

      final messageJson = jsonDecode(message) as Map<String, dynamic>;
      final data = messageJson["message"];
      final token = messageJson["token"];

      print("WS on request $messageJson");

      messageRepository.createMessage(data, token).then(
        (message) {
          channel.sink.add(
            jsonEncode({
              'event': 'message.created',
              'data': message,
            }),
          );
        },
      ).catchError((err) {
        print('Something went wrong $err');
      });

      // switch (event) {
      //   case 'message.created':
      //     messageRepository.createMessage(data, token).then(
      //       (message) {
      //         channel.sink.add(
      //           jsonEncode({
      //             'event': 'message.created',
      //             'data': message,
      //           }),
      //         );
      //       },
      //     ).catchError((err) {
      //       print('Something went wrong $err');
      //     });
      //     break;
      // case 'message.received':
      //   print("MESSAGE RECEIVER $messageJson");
      //   messageRepository
      //       .updateMessage(data["receiver_user_id"])
      //       .then((value) {
      //     channel.sink.add(
      //       jsonEncode({
      //         'event': 'message.received',
      //         'data': message,
      //       }),
      //     );
      //   });
      //   default:
      // }
    });
  });
  return handler(context);
}

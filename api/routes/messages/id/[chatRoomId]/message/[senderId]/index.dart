import 'dart:async';
import 'dart:io';

import 'package:api/src/repositories/message_repository.dart';
import 'package:dart_frog/dart_frog.dart';

FutureOr<Response> onRequest(
    RequestContext context, String chatRoomId, String senderId) {
  if (context.request.method == HttpMethod.get) {
    return _get(context, chatRoomId, senderId);
  } else {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(
    RequestContext context, String chatRoomId, String senderId) async {
  final messageRepository = context.read<MessageRepository>();
  try {
    final messages =
        await messageRepository.fetchMessages(chatRoomId, senderId);
    return Response.json(body: {"messages": messages});
  } catch (e, st) {
    print("ERROR FROM _GET $e $st");
    return Response.json(
      body: {'error': e.toString()},
      statusCode: HttpStatus.internalServerError,
    );
  }
}

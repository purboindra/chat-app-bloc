import 'dart:async';
import 'dart:io';

import 'package:api/src/repositories/message_repository.dart';
import 'package:dart_frog/dart_frog.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.get) {
    return _get(context);
  } else {
    return Response(statusCode: HttpStatus.badRequest);
  }
}

Future<Response> _get(RequestContext context) async {
  final messageRepository = context.read<MessageRepository>();
  try {
    final response = await messageRepository.fetchAllMessages();
    return Response.json(statusCode: HttpStatus.ok, body: {
      "data": response,
    });
  } catch (e) {
    print('ERROR GET ALL CHATS $e');
    return Response(statusCode: HttpStatus.internalServerError);
  }
}

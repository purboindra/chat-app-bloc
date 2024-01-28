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
  final request = await context.request;
  final headers = request.headers;

  if (headers[HttpHeaders.authorizationHeader] == null)
    return Response.json(
        statusCode: HttpStatus.unauthorized,
        body: {"data": null, "message": "Unauthorized"});

  final response = await messageRepository
      .fetchAllMessages(headers[HttpHeaders.authorizationHeader]!);

  return Response.json(statusCode: response["status_code"], body: {
    "data": response["data"],
    "message": response["message"],
  });
}

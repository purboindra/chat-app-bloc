import 'dart:async';
import 'dart:io';

import 'package:api/src/repositories/message_repository.dart';
import 'package:dart_frog/dart_frog.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  final method = context.request.method;
  if (method == HttpMethod.post) {
    return _post(context);
  } else {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _post(RequestContext context) async {
  final messageRepository = context.read<MessageRepository>();
  final request = await context.request;
  final headers = request.headers;
  final data = await request.json();

  if (headers[HttpHeaders.authorizationHeader] == null)
    return Response.json(
        statusCode: HttpStatus.unauthorized,
        body: {"data": null, "message": "Unauthorized"});

  final response = await messageRepository.createMessage(
      data, headers[HttpHeaders.authorizationHeader] ?? "");
  return Response.json(
    statusCode: HttpStatus.ok,
    body: {
      "status_code": HttpStatus.ok,
      "data": response,
      "message": "Success send a message",
    },
  );
}

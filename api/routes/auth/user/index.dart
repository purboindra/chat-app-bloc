import 'dart:async';
import 'dart:io';

import 'package:api/src/repositories/auth_repository.dart';
import 'package:dart_frog/dart_frog.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.get) {
    return await _get(context);
  } else {
    return Response(statusCode: HttpStatus.badRequest);
  }
}

Future<Response> _get(RequestContext context) async {
  final authRepository = context.read<AuthRepository>();
  final queryParams = context.request.uri.queryParameters;

  if (queryParams["uid"] == null)
    return Response(statusCode: HttpStatus.unauthorized);

  final response = await authRepository.fetchUser(uid: queryParams["uid"]!);
  return Response.json(body: {
    "message": "Success get user",
    "data": response,
  });
}

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
  final response = await authRepository.signOut();
  if (response!["status_code"] != HttpStatus.ok)
    return Response(statusCode: response["status_code"]);
  return Response(statusCode: HttpStatus.ok);
}

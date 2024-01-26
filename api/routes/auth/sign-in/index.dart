import 'dart:async';
import 'dart:io';

import 'package:api/src/repositories/auth_repository.dart';
import 'package:dart_frog/dart_frog.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.post) {
    return _signIn(context);
  } else {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _signIn(RequestContext context) async {
  final authRepository = context.read<AuthRepository>();
  final body = await context.request.json() as Map<String, dynamic>;
  try {
    final email = body["email"] as String?;
    final password = body["password"] as String?;
    if (email != null && password != null) {
      final response =
          await authRepository.singIn(email: email, password: password);
      if (response["data"] == null) {
        return Response.json(body: {
          "data": null,
          "status_code": HttpStatus.badRequest,
          "message": response["message"],
        });
      }
      return Response.json(
        body: {
          "data": response["data"],
          "message": response["message"],
          "status_code": HttpStatus.ok,
        },
      );
    }
    return Response.json(statusCode: HttpStatus.badRequest);
  } catch (e, st) {
    print("ERROR FROM SIGN IN $e $st");
    return Response.json(
      body: {
        "message": "Sorry, something went wrong!",
        "data": null,
      },
      statusCode: HttpStatus.internalServerError,
    );
  }
}

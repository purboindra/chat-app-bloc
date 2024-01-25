import 'dart:async';
import 'dart:io';

import 'package:api/src/repositories/auth_repository.dart';
import 'package:dart_frog/dart_frog.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.post) {
    return _signUp(context);
  } else {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _signUp(RequestContext context) async {
  final authRepository = context.read<AuthRepository>();
  final body = await context.request.json() as Map<String, dynamic>;
  try {
    final email = body["email"] as String?;
    final password = body["password"] as String?;
    if (email != null && password != null) {
      final response =
          await authRepository.signUp(email: email, password: password);
      if (response!["message"] != null) {
        return Response.json(
          body: {
            "data": null,
            "message": response["message"],
          },
          statusCode: HttpStatus.internalServerError,
        );
      }
      return Response.json(body: {
        "data": response["data"],
        "message": "Register Successfully!",
      }, statusCode: HttpStatus.ok);
    }
    return Response(statusCode: HttpStatus.badRequest);
  } catch (e, st) {
    print("ERROR FROM SIGN UP $e $st");
    return Response.json(
      body: {
        "message": e.toString(),
        "data": null,
      },
      statusCode: HttpStatus.internalServerError,
    );
  }
}

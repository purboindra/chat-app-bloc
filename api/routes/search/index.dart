import 'dart:async';
import 'dart:io';

import 'package:api/src/repositories/search_repository.dart';
import 'package:dart_frog/dart_frog.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.get) {
    return _get(context);
  } else {
    return Response(statusCode: HttpStatus.badRequest);
  }
}

Future<Response> _get(RequestContext context) async {
  final searchRepo = context.read<SearchRepository>();
  final request = context.request;
  final queryParams = request.uri.queryParameters;
  final headers = request.headers;

  if (headers[HttpHeaders.authorizationHeader] == null)
    return Response.json(
        statusCode: HttpStatus.unauthorized,
        body: {"data": [], "message": "Invalid Token Credentials"});

  if (queryParams["name"] == null)
    return Response.json(
        statusCode: HttpStatus.ok,
        body: {"data": [], "message": "No User Found"});

  final response = await searchRepo.searchUser(
      request.uri.queryParameters["name"]!,
      headers[HttpHeaders.authorizationHeader]!);

  return Response.json(
      statusCode: response["status_code"],
      body: {"data": response["data"], "message": response["message"]});
}

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
  final response =
      await searchRepo.searchUser(request.uri.queryParameters["name"] ?? "");
  print("DATA SEARCH _GET $response");
  return Response.json(
      statusCode: response["status_code"],
      body: {"data": response["data"], "message": response["message"]});
}

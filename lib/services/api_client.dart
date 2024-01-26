import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chat_app/data/entities/user_entity.dart';
import 'package:http/http.dart' as http;

typedef TokenProvider = Future<String?> Function();

class ApiClient {
  ApiClient({
    required TokenProvider tokenProvider,
    http.Client? httpClient,
  }) : this._(
            tokenProvider: tokenProvider,
            httpClient: httpClient,
            baseUrl: 'http://localhost:8080');

  ApiClient._({
    required TokenProvider tokenProvider,
    required String baseUrl,
    http.Client? httpClient,
  })  : _baseUrl = baseUrl,
        _httpClient = httpClient ?? http.Client(),
        _tokenProvider = tokenProvider;

  final TokenProvider _tokenProvider;
  final String _baseUrl;
  final http.Client _httpClient;

  Future<Map<String, dynamic>> fetchMessages(String chatRoomId) async {
    final uri = Uri.parse('$_baseUrl/chat-rooms/id/$chatRoomId/messages');
    final response = await _handleRequest(
        (headers) => _httpClient.get(uri, headers: headers));
    return response;
  }

  Future<List<Map<String, dynamic>>> fetchAllMessages() async {
    final uri = Uri.parse('$_baseUrl/chat-rooms');
    final response = await http.get(uri);
    final decode = jsonDecode(response.body);
    if (decode != null) {
      return [];
    }
    final data = List<Map<String, dynamic>>.from(decode["data"]);
    return data;
  }

  Future<UserEntity?> signUp(String email, String password) async {
    final uri = Uri.parse('$_baseUrl/auth/sign-up');
    final response = await http.post(uri,
        body: jsonEncode({"email": email, "password": password}));
    final decodeData = jsonDecode(response.body);
    if (response.statusCode != HttpStatus.ok) {
      throw Exception(
          "${response.statusCode}, error: ${decodeData["message"]}");
    }
    if (decodeData["data"] == null) return null;
    final user = UserEntity.fromJson(decodeData["data"]);
    return user;
  }

  Future<UserEntity?> signIn(String email, String password) async {
    final uri = Uri.parse('$_baseUrl/auth/sign-in');
    final response = await http.post(uri,
        body: jsonEncode({"email": email, "password": password}));
    final decodeData = jsonDecode(response.body);
    log("SIG IN $decodeData");
    if (response.statusCode != HttpStatus.ok) {
      throw Exception(
          "${response.statusCode}, error: ${decodeData["message"]}");
    }
    if (decodeData["data"] == null) return null;
    final user = UserEntity.fromJson(decodeData["data"]);
    log("USER ${user.email}");
    return user;
  }

  Future<Map<String, dynamic>> _handleRequest(
    Future<http.Response> Function(Map<String, String>) request,
  ) async {
    try {
      final headers = await _getRequestHeaders();
      final response = await request(headers);
      final body = jsonDecode(response.body);
      if (response.statusCode != HttpStatus.ok) {
        throw Exception("${response.statusCode}, error: ${body["message"]}");
      }
      if (response.request!.method == "POST") {
        return {
          "data": body,
          "status_code": response.statusCode,
        };
      }
      return body;
    } on TimeoutException {
      throw Exception("Request timeout. Please try again...");
    } catch (e, st) {
      throw Exception("Unexpected error: $e $st");
    }
  }

  Future<Map<String, String>> _getRequestHeaders() async {
    final token = await _tokenProvider();
    return <String, String>{
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.acceptHeader: ContentType.json.value,
      if (token != null) HttpHeaders.authorizationHeader: "Bearer $token"
    };
  }
}

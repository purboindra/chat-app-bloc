import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chat_app/data/entities/user_entity.dart';
import 'package:chat_app/env/env.dart';
import 'package:http/http.dart' as http;
import 'package:models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef TokenProvider = Future<String?> Function();

class ApiClient {
  ApiClient({
    required TokenProvider tokenProvider,
    http.Client? httpClient,
  }) : this._(
            tokenProvider: tokenProvider,
            httpClient: httpClient,
            baseUrl:
                'http://${Platform.isAndroid ? Env.IP : "localhost"}:8080');

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

  Future<void> signOut() async {
    final uri = Uri.parse('$_baseUrl/auth/sign-out');
    final response = await http.get(uri);
    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to log out');
    }
  }

  Future<List<UserEntity>> searchUser(String query, String token) async {
    List<UserEntity> users = [];
    final uri = Uri.parse('$_baseUrl/search?name=$query');

    final response = await _httpClient.get(uri, headers: {
      HttpHeaders.authorizationHeader: token,
    });
    final decode = jsonDecode(response.body);
    if (decode == null) {
      return users;
    }
    for (final user in decode["data"]) {
      users.add(UserEntity.fromJson(user as Map<String, dynamic>));
    }

    return users;
  }

  Future<void> createMessage(Message message, String token) async {
    final uri = Uri.parse("$_baseUrl/messages/create-message");
    final response = await _httpClient
        .post(uri, body: jsonEncode(message.toJson()), headers: {
      HttpHeaders.authorizationHeader: token,
    });

    if (response.statusCode != HttpStatus.ok) {
      throw Exception("${response.statusCode}, error: ${response.body}");
    }
  }

  Future<Map<String, dynamic>> fetchMessages(
      String chatRoomId, String senderId) async {
    final uri =
        Uri.parse('$_baseUrl/messages/id/$chatRoomId/message/$senderId');

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token") ?? "";
    final response = await _httpClient.get(uri, headers: {
      HttpHeaders.authorizationHeader: token,
    });
    return jsonDecode(response.body);
  }

  Future<List<Map<String, dynamic>>> fetchAllMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token") ?? "";
    final uri = Uri.parse('$_baseUrl/messages');
    final response = await _httpClient
        .get(uri, headers: {HttpHeaders.authorizationHeader: token});
    final decode = jsonDecode(response.body);
    if (decode == null) {
      return [];
    }

    final data = List<Map<String, dynamic>>.from(decode["data"]);

    return data;
  }

  Future<UserEntity?> fetchUser(String id) async {
    final uri = Uri.parse("$_baseUrl/auth/user?uid=$id");
    final response = await _httpClient.get(uri);
    final decodeData = jsonDecode(response.body);
    if (response.statusCode != HttpStatus.ok) {
      throw Exception(
          "${response.statusCode}, error: ${decodeData["message"]}");
    }
    return UserEntity.fromJson(decodeData["data"]["data"]);
  }

  Future<UserEntity?> signUp(String email, String password) async {
    final uri = Uri.parse('$_baseUrl/auth/sign-up');
    final response = await _httpClient.post(uri,
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
    final response = await _httpClient.post(uri,
        body: jsonEncode({"email": email, "password": password}));
    final decodeData = jsonDecode(response.body);
    if (response.statusCode != HttpStatus.ok) {
      throw Exception(
          "${response.statusCode}, error: ${decodeData["message"]}");
    }
    if (decodeData["data"] == null) return null;
    final user = UserEntity.fromJson(decodeData["data"]);
    log("USER ${user.email}");
    return user;
  }

  // Future<Map<String, dynamic>> _handleRequest(
  //   Future<http.Response> Function(Map<String, String>) request,
  // ) async {
  //   try {
  //     final headers = await _getRequestHeaders();
  //     final response = await request(headers);
  //     final body = jsonDecode(response.body);
  //     if (response.statusCode != HttpStatus.ok) {
  //       throw Exception("${response.statusCode}, error: ${body["message"]}");
  //     }
  //     if (response.request!.method == "POST") {
  //       return {
  //         "data": body,
  //         "status_code": response.statusCode,
  //       };
  //     }
  //     return body;
  //   } on TimeoutException {
  //     throw Exception("Request timeout. Please try again...");
  //   } catch (e, st) {
  //     throw Exception("Unexpected error: $e $st");
  //   }
  // }

  // Future<Map<String, String>> _getRequestHeaders() async {
  //   final token = await _tokenProvider();
  //   return <String, String>{
  //     HttpHeaders.contentTypeHeader: ContentType.json.value,
  //     HttpHeaders.acceptHeader: ContentType.json.value,

  //     // if (token != null)
  //     HttpHeaders.authorizationHeader: "Bearer $token"
  //   };
  // }
}

import 'dart:io';

import 'package:supabase/supabase.dart';

class MessageRepository {
  MessageRepository({required this.dbClient});
  final SupabaseClient dbClient;

  Future<Map<String, dynamic>> createMessage(Map<String, dynamic> data) async {
    try {
      final response =
          await dbClient.from("messages").insert(data).select().single();
      return response;
    } catch (e, st) {
      print("EROR BOS $e, st: $st");
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> fetchAllMessages(String token) async {
    try {
      final response =
          await dbClient.from("chat_rooms").select("*").eq("token", token);

      print("RESPONSE FETCH ALL MESSAGES $response");

      return {
        "message": "Success Get All Messages",
        "status_code": HttpStatus.ok,
        "data": response,
      };
    } catch (e) {
      print('ERRORR $e');
      return {
        "message": "$e",
        "status_code": HttpStatus.internalServerError,
        "data": [],
      };
    }
  }

  Future<List<Map<String, dynamic>>> fetchMessages(String chatRoomId) async {
    try {
      return await dbClient
          .from("messages")
          .select()
          .eq("chat_room_id", chatRoomId);
    } catch (e) {
      throw Exception(e);
    }
  }
}

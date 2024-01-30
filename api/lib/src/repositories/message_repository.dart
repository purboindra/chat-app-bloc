import 'dart:io';

import 'package:supabase/supabase.dart';

class MessageRepository {
  MessageRepository({required this.dbClient});
  final SupabaseClient dbClient;

  Future<Map<String, dynamic>> createMessage(
      Map<String, dynamic> data, String token) async {
    try {
      final chatRooms = await dbClient
          .from("chat_rooms")
          .select()
          .eq("id", data["receiver_user_id"])
          .select();

      final response = await dbClient.from("messages").insert(data).select();

      if (chatRooms.isEmpty) {
        await dbClient.from("chat_rooms").insert({
          "user_id": data["sender_user_id"],
          "id": data["receiver_user_id"],
          "token": token,
        }).select();
      } else {
        await dbClient.from("chat_rooms").update({
          "last_message_id": response.first["id"],
          "created_at": response.first["created_at"]
        }).eq("id", data["receiver_user_id"]);
      }

      return response.first;
    } catch (e, st) {
      print("EROR CREATE MESSAGE $e, st: $st");
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> fetchAllMessages(String token) async {
    try {
      List<dynamic> userData = [];

      final response = await dbClient
          .from("chat_rooms")
          .select('*, users(*)')
          .eq("token", token)
          .order("created_at", ascending: false);

      for (final data in response) {
        userData.add({"user": data["users"], "messages": data});
      }

      return {
        "message": "Success Get All Messages",
        "status_code": HttpStatus.ok,
        "data": userData,
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

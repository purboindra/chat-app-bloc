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
          "last_message_id": response.first["id"],
          "sender_id": data["sender_user_id"],
          "id": data["receiver_user_id"],
          "token": token,
        });
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

  Future<List<Map<String, dynamic>>> fetchMessages(
      String chatRoomId, String senderId) async {
    try {
      print("CHAT ROOM ID $chatRoomId - SENDER ID $senderId");

      // final response = await dbClient
      //     .from("messages")
      //     .select("*")
      //     .eq("sender_user_id", senderId)
      //     .eq("chat_room_id", chatRoomId)
      //     .select("*");

      final response = await dbClient.from("messages").select();
      // .match({
      //   "chat_room_id": chatRoomId,
      //   "sender_user_id": senderId,
      // }).match({
      //   "chat_room_id": senderId,
      //   "sender_user_id": chatRoomId,
      // })
      //     .select();

      print('SASA $response');

      return response;
    } catch (e) {
      throw Exception(e);
    }
  }
}

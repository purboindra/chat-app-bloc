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

  Future<List<Map<String, dynamic>>> fetchAllMessages() async {
    try {
      final response = await dbClient
          .from("chat_rooms")
          .select("*")
          .eq("user_id", "${dbClient.auth.currentUser!.id}");

      print("RESPONSE FETCH ALL MESSAGES $response");

      return response;
    } catch (e) {
      print('ERRORR $e');
      throw Exception(e);
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

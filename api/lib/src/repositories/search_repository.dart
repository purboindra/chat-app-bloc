import 'dart:io';

import 'package:supabase/supabase.dart';

class SearchRepository {
  SearchRepository(this.dbClient);

  final SupabaseClient dbClient;

  Future<Map<String, dynamic>> searchUser(String query, String token) async {
    try {
      final response = await dbClient
          .from("users")
          .select("*")
          .neq('token', token)
          .textSearch("username", query);

      return {
        "message": "Success Search User",
        "status_code": HttpStatus.ok,
        "data": response,
      };
    } catch (e, st) {
      print("EROR SEARCH $e, st: $st");
      return {
        "message": "$e",
        "status_code": HttpStatus.internalServerError,
        "data": null,
      };
    }
  }
}

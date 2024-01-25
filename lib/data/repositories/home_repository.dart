import 'package:chat_app/services/api_client.dart';

class HomeRepository {
  final ApiClient apiClient;

  HomeRepository(this.apiClient);

  Future<List<Map<String, dynamic>>> fetchAllMessages() async {
    final response = await apiClient.fetchAllMessages();
    return response;
  }
}

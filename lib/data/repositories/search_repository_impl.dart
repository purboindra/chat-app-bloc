import 'package:chat_app/data/entities/user_entity.dart';
import 'package:chat_app/domain/repositories/search_repository.dart';
import 'package:chat_app/services/api_client.dart';

class SearchRepositoryImpl implements SearchRepository {
  final ApiClient apiClient;

  const SearchRepositoryImpl(this.apiClient);

  @override
  Future<List<UserEntity>> searchUser(String query) async {
    final response = await apiClient.searchUser(query);
    return response;
  }
}

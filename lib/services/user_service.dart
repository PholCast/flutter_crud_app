import 'dart:convert';
import 'package:flutter_crud_app/models/user_model.dart';
import 'package:flutter_crud_app/models/users_response.dart';
import 'package:http/http.dart' as http; // * libreria http para consumir la api

class UserService {
  final String baseUrl = 'https://dummyjson.com/users';

  Future<UsersResponse> fetchUsers({
    required int limit,
    required int skip,
  }) async {
    final uri = Uri.parse('$baseUrl?limit=$limit&skip=$skip');
    final response = await http.get(uri);

    if(response.statusCode != 200){
      throw Exception('HTTP ${response.statusCode}: ${response.reasonPhrase} (Failed to load users)');
    }

    final data = json.decode(response.body) as Map<String, dynamic>;
    final List usersJson = data['users'] as List? ?? [];

    List <User> users = usersJson.map((userJson) => User.fromJson(userJson)).toList();
    
    return UsersResponse(
      users: users, 
      total:(data['total'] as int?)?.toInt() ?? 0,
      skip: (data['skip'] as int?)?.toInt() ?? skip,
      limit:(data['limit'] as int?)?.toInt() ?? limit
    );
  }

  Future<void> deleteUser(int id) async{
    final uri = Uri.parse('$baseUrl/$id');
    final response = await http.delete(uri);

    if(response.statusCode != 200){
      throw Exception('HTTP ${response.statusCode}: ${response.reasonPhrase} (Error al borrar usuario)');
    }

  }
}
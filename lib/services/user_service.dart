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

  Future<bool> deleteUser(int id) async{
    final uri = Uri.parse('$baseUrl/$id');
    final response = await http.delete(uri);

    if(response.statusCode != 200){
      throw Exception('HTTP ${response.statusCode}: ${response.reasonPhrase} (Error deleting user)');
    }

    final data = json.decode(response.body) as Map<String, dynamic>;
    return data['isDeleted'] == true;

  }

  Future<User> updateUser( User updatedData) async {
    final uri = Uri.parse('$baseUrl/${updatedData.id}');
    final response = await http.patch(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updatedData.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode}: ${response.reasonPhrase} (Error updating user)');
    }
    final data = json.decode(response.body) as Map<String, dynamic>;
    return User.fromJson(data);
  }


  Future<User> createUser(User newUserData) async {
    final uri = Uri.parse('$baseUrl/add');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(newUserData.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('HTTP ${response.statusCode}: ${response.reasonPhrase} (Error creating user)');
    }
    final data = json.decode(response.body) as Map<String, dynamic>;
    return User.fromJson(data);
  }

}
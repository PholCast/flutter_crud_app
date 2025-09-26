
import 'package:flutter_crud_app/models/user_model.dart';

class UsersResponse {
  final List<User> users;
  final int total;
  final int skip;
  final int limit;

  UsersResponse({
    required this.users,
    required this.total,
    required this.skip,
    required this.limit,
  });
  
}
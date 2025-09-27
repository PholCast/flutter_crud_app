import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class UserProvider extends ChangeNotifier {
  final UserService _service = UserService();

  final List<User> _users = [];
  int _total = 0;
  final int _pageSize = 10;
  bool _isLoading = false;
  bool _firstLoadDone = false;
  String? _error;


  List<User> get users => List.unmodifiable(_users);
  int get total => _total;
  int get pageSize => _pageSize;
  bool get isLoading => _isLoading;
  bool get firstLoadDone => _firstLoadDone;
  String? get error => _error;

  bool get hasMore =>
      _users.length < _total || (!_firstLoadDone && !_isLoading);

  Future<void> getUsers() async {
    if (_isLoading || !hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _service.fetchUsers(
        limit: _pageSize,
        skip: _users.length,
      );

      _users.addAll(response.users);
      _total = response.total;
      _firstLoadDone = true;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> onRefresh() async {
    _users.clear();
    _total = 0;
    _firstLoadDone = false;
    _error = null;
    notifyListeners();
    await getUsers();
  }

  Future<void> deleteUser(int id) async {
  try {
    await _service.deleteUser(id);
    _users.removeWhere((user) => user.id == id);
    _total--; // opcional, ajusta el total
    notifyListeners();
  } catch (e) {
    _error = e.toString();
    notifyListeners();
  }
}

}

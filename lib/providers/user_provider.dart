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
      if (id != 209) {
        await _service.deleteUser(id);
        print('si se hizo el delete en el service');
      }

      _users.removeWhere((user) => user.id == id);
      _total--; 
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> createUser(User user) async {
    try {
      final newUser = await _service.createUser(user);
      print('el id del usuario nuevo es ${newUser.id}');
      _users.insert(0, newUser); 
      _total++;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

Future<void> updateUser(User user) async {
  try {
    if (user.id < 209) {

      final updatedUser = await _service.updateUser(user);
      final index = _users.indexWhere((u) => u.id == user.id);
      
      if (index != -1) _users[index] = updatedUser;
      print('Update en API');
    } else {
      final index = _users.indexWhere((u) => u.id == user.id);
      if (index != -1) _users[index] = user;
      print('Update local, id=${user.id}');
    }

    _error = null;
    notifyListeners();
  } catch (e) {
    _error = e.toString();
    notifyListeners();
  }
  }
}

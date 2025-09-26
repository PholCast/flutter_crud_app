import 'package:flutter/material.dart';
import 'package:flutter_crud_app/components/error_tile.dart';
import 'package:flutter_crud_app/components/user_tile.dart';
import 'package:flutter_crud_app/models/user_model.dart';
import 'package:flutter_crud_app/repositories/user_repository.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final TextEditingController _controller = TextEditingController();
  String _searchValue = '';

  final UserRepository _repo = UserRepository();
  List<User> users = [];

  ScrollController _scrollController = ScrollController();
  int total = 0;
  int pagesize = 10;
  bool isLoading = false;
  bool firstLoadDone = false;

  String? _error;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    getUsers();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      print('loading more users...');
      getUsers();
    }
  }

  bool get _hasMore => users.length < total || (!firstLoadDone && !isLoading);

  Future<void> getUsers() async {
    if (isLoading || !_hasMore) return;

    try {
      setState(() {
        isLoading = true;
      });

      final usersResponse = await _repo.fetchUsers(
        limit: pagesize,
        skip: users.length,
      );
      setState(() {
        users.addAll(usersResponse.users);
        total = usersResponse.total;
        firstLoadDone = true;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _onRefresh() async {
    setState(() {
      users.clear();
      total = 0;
      firstLoadDone = false;
      _error = null;
    });
    await getUsers();
  }

  List<User> get _filteredUsers {
    if (_searchValue.isEmpty) return users;
    final query = _searchValue.toLowerCase();

    return users
        .where(
          (user) =>
              user.firstName.toLowerCase().contains(query) ||
              user.lastName.toLowerCase().contains(query) ||
              user.title.toLowerCase().contains(query) ||
              ('${user.firstName} ${user.lastName}').toLowerCase().contains(query),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Users Page')),
      body: _error != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [ErrorTile(message: _error!, onRetry: getUsers)],
            )
          : RefreshIndicator(
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          labelText: 'Buscar',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchValue = value.toLowerCase();
                          });
                        },
                      ),
                    ),
                    ..._filteredUsers.map((user) => UserTile(user: user)),
                    if (isLoading)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: CircularProgressIndicator(),
                      ),
                    if (_error != null)
                      ErrorTile(message: _error!, onRetry: getUsers),
                  ],
                ),
              ),
            ),
    );
  }
}

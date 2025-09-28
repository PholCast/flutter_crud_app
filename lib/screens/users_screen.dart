import 'package:flutter/material.dart';
import 'package:provider/provider.dart';              
import 'package:flutter_crud_app/components/error_tile.dart';
import 'package:flutter_crud_app/components/user_tile.dart';
import 'package:flutter_crud_app/models/user_model.dart';
import 'package:flutter_crud_app/screens/form_screen.dart';
import 'package:flutter_crud_app/providers/user_provider.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _searchValue = '';

  @override
  void initState() {
    super.initState();

    final userProv = context.read<UserProvider>();
    userProv.getUsers();

    _scrollController.addListener(() {
      final prov = context.read<UserProvider>();
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        if (prov.hasMore && !prov.isLoading) {
          prov.getUsers();
        }
      }
    });
  }

  List<User> _filtered(List<User> users) {
    if (_searchValue.isEmpty) return users;
    final q = _searchValue.toLowerCase();
    return users.where((u) =>
        u.firstName.toLowerCase().contains(q) ||
        u.lastName.toLowerCase().contains(q) ||
        (u.title).toLowerCase().contains(q) ||
        ('${u.firstName} ${u.lastName}').toLowerCase().contains(q)).toList();
  }

  
  Future<void> _deleteUser(User u) async {
    try {
      await context.read<UserProvider>().deleteUser(u.id);

      if(!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User deleted')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Users Page'),
        backgroundColor: Color.fromRGBO(0, 75, 254, 1),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_rounded, size: 28),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FormScreen()),
            ),
          ),
        ],
      ),

      body: Consumer<UserProvider>(
        builder: (context, prov, _) {
          if (prov.error != null) {
            return Center(
              child: ErrorTile(
                message: prov.error!,
                onRetry: prov.getUsers, 
              ),
            );
          }

          final filtered = _filtered(prov.users);

          return RefreshIndicator(
            onRefresh: prov.onRefresh, 
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromRGBO(246, 245, 244,1),
                        prefixIconColor: Color.fromRGBO(98, 98, 98,1),
                        hintText: 'Search',
                        hintStyle: TextStyle(color: Color.fromRGBO(98, 98, 98,1)),
                        prefixIcon: const Icon(Icons.search,size: 27,),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(60),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(60),
                          borderSide: const BorderSide(color: Color.fromRGBO(0, 75, 254, 1),width: 2.5),
                        ),
                      ),
                      onChanged: (value) =>
                          setState(() => _searchValue = value.toLowerCase()),
                    ),
                  ),
                  ...filtered.map((u) => UserTile(user: u,onDelete: () => _deleteUser(u))),
                  if (prov.isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
          );
        },
      )
    );
  }
}

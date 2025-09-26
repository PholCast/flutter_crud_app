import 'package:flutter/material.dart';
import 'package:provider/provider.dart';              
import 'package:flutter_crud_app/components/error_tile.dart';
import 'package:flutter_crud_app/components/user_tile.dart';
import 'package:flutter_crud_app/models/user_model.dart';
import 'package:flutter_crud_app/screens/form_page.dart';
import 'package:flutter_crud_app/providers/user_provider.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Users Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_rounded, size: 28),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FormPage()),
            ),
          ),
        ],
      ),

      body: Stack(
      children: [
        SizedBox.expand(
          child: Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
          ),
        ),
      
      Consumer<UserProvider>(
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
                        fillColor: Colors.white,
                        prefixIconColor: Color.fromRGBO(0, 75, 254, 1),
                        hintText: 'Buscar',
                        hintStyle: TextStyle(color: Colors.grey.shade700),
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(60),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(60),
                          borderSide: const BorderSide(color: Colors.blueAccent),
                        ),
                      ),
                      onChanged: (value) =>
                          setState(() => _searchValue = value.toLowerCase()),
                    ),
                  ),
                  ...filtered.map((u) => UserTile(user: u)),
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
      ),])
    );
  }
}

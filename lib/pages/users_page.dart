import 'package:flutter/material.dart';
import 'package:flutter_crud_app/components/user_tile.dart';
import 'package:flutter_crud_app/models/user_model.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final List<User> users = [
    const User(
      id: '1',
      firstName: 'Ana',
      lastName: 'Gómez',
      username: 'anagomez',
      email: 'ana.gomez@example.com',
      age: 28,
      title: 'Software Engineer',
      image: 'assets/images/blue-circle.jpg',
    ),
    const User(
      id: '2',
      firstName: 'Luis',
      lastName: 'Martínez',
      username: 'luism',
      email: 'luis.martinez@example.com',
      age: 35,
      title: 'Product Manager',
      image: 'assets/images/blue-circle.jpg',
    ),
    const User(
      id: '3',
      firstName: 'Carla',
      lastName: 'Fernández',
      username: 'cfernandez',
      email: 'carla.fernandez@example.com',
      age: 30,
      title: 'UX Designer',
      image: 'assets/images/blue-circle.jpg',
    ),
    const User(
      id: '4',
      firstName: 'David',
      lastName: 'Sánchez',
      username: 'davids',
      email: 'david.sanchez@example.com',
      age: 40,
      title: 'DevOps Engineer',
      image: 'assets/images/blue-circle.jpg',
    ),
    const User(
      id: '5',
      firstName: 'María',
      lastName: 'López',
      username: 'marial',
      email: 'maria.lopez@example.com',
      age: 26,
      title: 'QA Analyst',
      image: 'assets/images/blue-circle.jpg',
    ),
    const User(
      id: '6',
      firstName: 'Juan',
      lastName: 'Ruiz',
      username: 'juanruiz',
      email: 'juan.ruiz@example.com',
      age: 32,
      title: 'Data Scientist',
      image: 'assets/images/blue-circle.jpg',
    ),
    const User(
      id: '7',
      firstName: 'Phol',
      lastName: 'Cast',
      username: 'Pholcast',
      email: 'phol@example.com',
      age: 21,
      title: 'Pull stack engineer',
      image: 'assets/images/blue-circle.jpg',
    ),
  ];

  final TextEditingController _controller = TextEditingController();
  String _searchValue = '';

  List<User> get _filteredUsers{
    if(_searchValue.isEmpty) return users;
    final query = _searchValue.toLowerCase();

    return users
        .where(
          (user) => 
             user.firstName.toLowerCase().contains(query) ||
             user.lastName.toLowerCase().contains(query) ||
             user.username.toLowerCase().contains(query) ||
             user.title.toLowerCase().contains(query) ||
             ('${user.firstName} ${user.lastName}').toLowerCase().contains(query)
        )
        .toList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Users Page'),),
      body: SingleChildScrollView(child: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
        SizedBox(
          height: 800,
          child: ListView.builder(
            itemCount: _filteredUsers.length,
            itemBuilder:(context, index){
              final user = _filteredUsers[index];
              return UserTile(key: Key('$user.id'), user: user); //!mirar si toca cambiarlo por el nombre mejor
            },),
        )
      ],),)
      
    );
  }
}
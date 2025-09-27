import 'package:flutter/material.dart';
import 'package:flutter_crud_app/providers/user_provider.dart';
import 'package:flutter_crud_app/screens/users_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: const MyApp(),

    )

  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromRGBO(0, 75, 254, 1), brightness: Brightness.light),
        appBarTheme: AppBarTheme(backgroundColor: Color.fromRGBO(0, 75, 254, 1), foregroundColor: Colors.white),
      ),
      home: const UsersScreen(),
    );
  }
}



import 'package:flutter/material.dart';
import 'screens/home_login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Lato',
      ),
      home: const HomeLoginScreen(title: 'Learning App Login'),
    );
  }
}

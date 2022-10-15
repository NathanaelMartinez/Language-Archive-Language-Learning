import 'package:flutter/material.dart';

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
        primarySwatch: Colors.blue,
        fontFamily: 'Lato',
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.school,
              size: 130.0
            ),
            // Title pending...
            const Text(
              'Language Learning App',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'a crowd-sourced language learning application',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300
              ),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                  decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                  hintText: 'Please enter your email address'
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                  decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Please enter your password'
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black
              ),
              // TODO: Create Selection Screen
              onPressed: () { }, 
              child: const Text('Login')
            ),
            TextButton(
              // TODO: Create Registration Screen
              onPressed: () { }, 
              child: const Text('Sign Up')
            )
          ],
        ),
      )
    );
  }
}

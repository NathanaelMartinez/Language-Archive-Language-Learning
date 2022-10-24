import 'package:flutter/material.dart';
import 'create_account_screen.dart';
import 'selection_screen.dart';

class HomeLoginScreen extends StatefulWidget {
  const HomeLoginScreen({super.key});

  @override
  State<HomeLoginScreen> createState() => _HomeLoginScreenState();
}

class _HomeLoginScreenState extends State<HomeLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: OrientationBuilder(builder: (context, orientation) {
      if (orientation == Orientation.portrait) {
        return _portraitModeLogin();
      } else {
        return _landscapeModeLogin();
      }
    }));
  }

  Widget _portraitModeLogin() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.school,
            size: 130.0,
            color: Colors.black,
          ),
          // Title pending...
          const Text(
            'Language Learning App',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 5),
          const Text(
            'a crowd-sourced language learning application',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
          ),
          const SizedBox(height: 30),
          // TODO: Will be updated to forms later on
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  hintText: 'Please enter your email address'),
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Please enter your password'),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.black),
              // TODO: Will need to update for Auth0 login
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: ((context) => SelectionScreen())),
                );
              },
              child: const Text('Login')),
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => CreateAccountScreen())),
                );
              },
              child: const Text('Sign Up'))
        ],
      ),
    );
  }

  Widget _landscapeModeLogin() {
    return Center(
        child: Row(
      children: [
        Expanded(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.school, size: 100.0),
          // Title pending...
          const Text(
            'Language Learning App',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 5),
          const Text(
            'a crowd-sourced language learning application',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
          ),
        ])),
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: Will be updated to forms later on
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Please enter your email address'),
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Please enter your password'),
                )),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black),
                  // TODO: Will need to update for Auth0 login
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => SelectionScreen())),
                    );
                  },
                  child: const Text('Login')),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => CreateAccountScreen())),
                    );
                  },
                  child: const Text('Sign Up'))
            ]),
          ],
        ))
      ],
    ));
  }
}

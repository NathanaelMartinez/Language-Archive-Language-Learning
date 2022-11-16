import 'package:flutter/material.dart';
import 'create_account_screen.dart';
import 'selection_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeLoginScreen extends StatefulWidget {
  const HomeLoginScreen({super.key});

  @override
  State<HomeLoginScreen> createState() => _HomeLoginScreenState();
}

class _HomeLoginScreenState extends State<HomeLoginScreen> {
  var credential;
  final emailInput = TextEditingController();
  final passwordInput = TextEditingController();
  bool loginValid = false;

  @override
  void dispose() {
    emailInput.dispose();
    passwordInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation)  {
          return _homeLoginScreenDisplay(orientation);
        }
      )
    );
  }

  double determineMargin(currOrientation)  {
    if (currOrientation == Orientation.landscape) {
      return 40;
    } else  {
      return 150;
    }
  }

  Widget _homeLoginScreenDisplay(display) {
    return Center(
      child: ListView(
        children: [
          ListTile(
            title: Container(
              margin: EdgeInsets.only(
                left: 20, right: 20, top: determineMargin(display), bottom: 40),
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: TextField(
              controller: emailInput,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  hintText: 'Please enter your email address'),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: TextField(
              controller: passwordInput,
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
              onPressed: () async {
                try {
                  credential = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: emailInput.text, password: passwordInput.text);
                  loginValid = true;
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    final missingInput = const SnackBar(
                      content: Text(
                        'No user found for that email.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                      duration: const Duration(milliseconds: 2000),
                      backgroundColor: Colors.red,
                    );
                    loginValid = false;
                    ScaffoldMessenger.of(context).showSnackBar(missingInput);
                  } else if (e.code == 'wrong-password') {
                    final missingInput = const SnackBar(
                      content: Text(
                        'Wrong password provided for that user.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                      duration: const Duration(milliseconds: 2000),
                      backgroundColor: Colors.red,
                    );
                    loginValid = false;
                    ScaffoldMessenger.of(context).showSnackBar(missingInput);
                  }
                }
                if (emailInput.text.isEmpty || passwordInput.text.isEmpty) {
                  final missingInput = const SnackBar(
                    content: Text(
                      'Missing email and/or password input.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                    duration: const Duration(milliseconds: 2000),
                    backgroundColor: Colors.red,
                  );
                  loginValid = false;
                  ScaffoldMessenger.of(context).showSnackBar(missingInput);
                }
                if (loginValid) {
                  emailInput.clear();
                  passwordInput.clear();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => SelectionScreen(userCredentials: credential))),
                  );
                }
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
      )))],
    ));
  }
}

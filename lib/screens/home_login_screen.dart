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
                  final credential = await FirebaseAuth.instance
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => SelectionScreen())),
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
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
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  controller: passwordInput,
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
                  onPressed: () async {
                    try {
                      final credential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: emailInput.text,
                              password: passwordInput.text);
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
                        ScaffoldMessenger.of(context)
                            .showSnackBar(missingInput);
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
                        ScaffoldMessenger.of(context)
                            .showSnackBar(missingInput);
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => SelectionScreen())),
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
            ]),
          ],
        ))
      ],
    ));
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'selection_screen.dart';

class CreateAccountScreen extends StatefulWidget {
  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  late final credential;
  FirebaseFirestore db = FirebaseFirestore.instance;
  final nameInput = TextEditingController();
  final emailInput = TextEditingController();
  final passwordInput = TextEditingController();
  final confirmInput = TextEditingController();
  bool signUpValid = false;

  @override
  void dispose() {
    nameInput.dispose();
    emailInput.dispose();
    passwordInput.dispose();
    confirmInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: OrientationBuilder(builder: (context, orientation) {
      return _createAccountScreenDisplay(orientation);
    }));
  }

  double determineTopMargin(currOrientation) {
    if (currOrientation == Orientation.landscape) {
      return 40;
    } else {
      return 150;
    }
  }

  double determineBottomMargin(currOrientation) {
    if (currOrientation == Orientation.landscape) {
      return 40;
    } else {
      return 10;
    }
  }

  Widget _createAccountScreenDisplay(display) {
    return Center(
        child: ListView(children: [
      ListTile(
          title: Container(
              padding: EdgeInsets.only(
                  top: determineTopMargin(display),
                  bottom: determineBottomMargin(display)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Create Account',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                  ),
                  Container(
                      margin: const EdgeInsets.only(
                          left: 30, right: 30, bottom: 10, top: 30),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Colors.black),
                      child: Column(children: [
                        TextField(
                          controller: nameInput,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              labelStyle: TextStyle(color: Colors.white),
                              hintStyle: TextStyle(color: Colors.white),
                              labelText: 'Name',
                              hintText: 'Please enter your name'),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: emailInput,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              labelStyle: TextStyle(color: Colors.white),
                              hintStyle: TextStyle(color: Colors.white),
                              labelText: 'Email',
                              hintText: 'Please enter your email address'),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: passwordInput,
                          obscureText: true,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              labelStyle: TextStyle(color: Colors.white),
                              hintStyle: TextStyle(color: Colors.white),
                              labelText: 'Password',
                              hintText: 'Please enter your password'),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: confirmInput,
                          obscureText: true,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              labelStyle: TextStyle(color: Colors.white),
                              hintStyle: TextStyle(color: Colors.white),
                              labelText: 'Confirm Password',
                              hintText: 'Please re-enter your password'),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.green),
                                onPressed: () async {
                                  if (emailInput.text.isEmpty ||
                                      passwordInput.text.isEmpty ||
                                      nameInput.text.isEmpty ||
                                      confirmInput.text.isEmpty) {
                                    final missingInput = const SnackBar(
                                      content: Text(
                                        'Please fill in all fields.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      duration:
                                          const Duration(milliseconds: 2000),
                                      backgroundColor: Colors.red,
                                    );
                                    signUpValid = false;
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(missingInput);
                                  } else if (confirmInput.text !=
                                      passwordInput.text) {
                                    final invalidInput = const SnackBar(
                                      content: Text(
                                        'Password and confirmed password do not match.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      duration:
                                          const Duration(milliseconds: 2000),
                                      backgroundColor: Colors.red,
                                    );
                                    signUpValid = false;
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(invalidInput);
                                  } else {
                                    try {
                                      credential = await FirebaseAuth.instance
                                          .createUserWithEmailAndPassword(
                                        email: emailInput.text,
                                        password: passwordInput.text,
                                      );
                                      signUpValid = true;
                                    } on FirebaseAuthException catch (e) {
                                      if (e.code == 'weak-password') {
                                        final missingInput = const SnackBar(
                                          content: Text(
                                            'The password provided is too weak.',
                                            textAlign: TextAlign.center,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          duration: const Duration(
                                              milliseconds: 2000),
                                          backgroundColor: Colors.red,
                                        );
                                        signUpValid = false;
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(missingInput);
                                      } else if (e.code ==
                                          'email-already-in-use') {
                                        final missingInput = const SnackBar(
                                          content: Text(
                                            'The account already exists for that email.',
                                            textAlign: TextAlign.center,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          duration: const Duration(
                                              milliseconds: 2000),
                                          backgroundColor: Colors.red,
                                        );
                                        signUpValid = false;
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(missingInput);
                                      }
                                    } catch (e) {
                                      print(e);
                                    }
                                  }
                                  if (signUpValid) {
                                    final newUser = <String, dynamic>{
                                      "name": nameInput.text,
                                      "email": emailInput.text,
                                      "uid": credential.user.uid.toString(),
                                      "cpPoints": 0,
                                      "llPoints": 0
                                    };
                                    await db.collection("users").add(newUser);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              SelectionScreen(
                                                  userCredentials:
                                                      credential))),
                                    );
                                  }
                                },
                                child: const Text('Create your account')),
                            SizedBox(width: 10),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  side: BorderSide(color: Colors.red),
                                  foregroundColor: Colors.red,
                                  backgroundColor: Colors.black,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'))
                          ],
                        ),
                      ])),
                ],
              )))
    ]));
  }
}

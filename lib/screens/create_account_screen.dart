import 'package:flutter/material.dart';

class CreateAccountScreen extends StatefulWidget  {
  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen>  {
  @override
  Widget build(BuildContext context)  {
    return Scaffold(
      /*
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white10,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0
      ),
      */
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait)  {
            return _portraitModeCreateAccount();
          } else  {
            return _landscapeModeCreateAccount();
          }
        }
      )
    );
  }

  Widget _portraitModeCreateAccount() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Create Account',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w700 
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 30, right: 30, bottom: 10, top: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 3
              ),
              borderRadius: BorderRadius.all(Radius.circular(5))
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700 
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                TextField(
                    decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Please enter your email address'
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700 
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                TextField(
                    decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Please enter your password'
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Text(
                      'Confirm Password',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700 
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                TextField(
                    decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Please re-enter your password'
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black
                  ),
                  // TODO: Create Selection Screen
                  onPressed: () { }, 
                  child: const Text('Create your account')
                ),
                TextButton(
                  onPressed: () { 
                    Navigator.pop(context);
                  }, 
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.red
                    )
                  )
                )
              ]
            )
          ),
        ],
      )
    );
  }

  Widget _landscapeModeCreateAccount()  {
    return Center(
      child: Text('In Development...')
    );
  }
}
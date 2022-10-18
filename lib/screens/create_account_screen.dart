import 'package:flutter/material.dart';
import 'selection_screen.dart';

class CreateAccountScreen extends StatefulWidget  {
  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen>  {
  @override
  Widget build(BuildContext context)  {
    return Scaffold(
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
            margin: const EdgeInsets.only(left: 30, right: 30, bottom: 10, top: 30),
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
                TextField(
                    decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Please enter your email address'
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                    decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Please enter your password'
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                    decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Confirm Password',
                    hintText: 'Please re-enter your password'
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black
                      ),
                      // TODO: Will need to update for Auth0 login
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: ((context) => SelectionScreen())), 
                        );
                      }, 
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
                  ],
                ),
              ]
            )
          ),
        ],
      )
    );
  }

  Widget _landscapeModeCreateAccount()  {
    return Center(
      child: ListView(
        children: [
          SizedBox(height: 20),
          // Title
          ListTile(
            title: Center( 
              child: const Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700 
                ),
              ),
            )
          ),
          // Entry Container
          // TODO: Implement form later on
          ListTile(
            title: Container(
              margin: const EdgeInsets.only(left: 30, right: 30, bottom: 10, top: 20),
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 3
                ),
                borderRadius: BorderRadius.all(Radius.circular(5))
              ),
              child: Column(
                children: [
                  // Email entry box
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                            hintText: 'Please enter your email address'
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Password entry box
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                            hintText: 'Please enter your password'
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Confirm password confirmation box
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Confirm Password',
                            hintText: 'Please re-enter your password'
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.black
                          ),
                          // TODO: Will need to update for Auth0 sign in
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: ((context) => SelectionScreen())), 
                            );
                          }, 
                          child: const Text('Create your account')
                        ),
                      ),
                      Expanded(
                        child: TextButton(
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
                      )
                    ],
                  )
                ]
              ),
            )
          ),
          SizedBox(height: 10)
        ],
      ),
    );
  }
}
import 'package:cs467_language_learning_app/screens/home_login_screen.dart';
import 'package:flutter/material.dart';

class SelectionScreen extends StatefulWidget  {
  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen>  {
  @override
  Widget build(BuildContext context)  {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Welcome!',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 25
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: Colors.white10,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0
      ),
      endDrawer: Drawer(
        child: ListView(
          children: [
            // Logout button
            // TODO: Need to update routing
            ListTile(
              title: const Text('Log Out'),
              onTap: () {
                Navigator.pop(context);
              },
            )
          ],
        )
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait)  {
            return _portraitModeSelectionScreen();
          } else  {
            return _landscapeModeSelectionScreen();
          }
        }
      ),
    );
  }

  Widget _portraitModeSelectionScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Select a language to focus on:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500 
            ),
          ),
          Form(
            child: Column(
              children: [

              ],
            )
          )
        ],
      )
    );
  }

  Widget _landscapeModeSelectionScreen() {
    return Center(child: Text('landscape'));
  }
}
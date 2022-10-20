import 'package:flutter/material.dart';

class ContentProviderScenarioScreen extends StatefulWidget  {
  @override
  State<ContentProviderScenarioScreen> createState() => _ContentProviderScenarioScreenState();
}

class _ContentProviderScenarioScreenState extends State<ContentProviderScenarioScreen>  {
  @override
  Widget build(BuildContext context)  {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Scenario',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 25
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.white10,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      endDrawer: Drawer(
        child: ListView(
          children: [
            // Logout button
            ListTile(
              title: TextButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }, 
                child: const Text(
                  'Log Out',
                  style: TextStyle(
                    color: Colors.blue
                  ),
                )
              ),
            )
          ],
        )
      ),
    );
  }
}
import 'package:flutter/material.dart';
//import 'package:wasteagram/config.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      onTapHint: 'Open Settings',
      button: true,
      enabled: true,
      child: Drawer(
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
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

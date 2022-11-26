import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsDrawer extends StatelessWidget {
  SettingsDrawer({Key? key, required this.userInfo}) : super(key: key);
  final userInfo;

  Widget GetUserInfo(BuildContext context, value) {
    return new StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: userInfo.user.uid.toString())
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return new Text('Loading...', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300));
        } else {
          var userData = snapshot.data!.docs[0];
          if (value == 0) {
            return new Text(userData['name'], style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300));
          } else if (value == 1) {
            return new Text(userData['email'], style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300));
          } else if (value == 2) {
            return new Text('${userData['cpPoints']}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300));
          } else {
            return new Text('${userData['llPoints']}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300));
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      onTapHint: 'Open Settings',
      button: true,
      enabled: true,
      child: Drawer(
        child: ListView(
          children: [
            SizedBox(height: 10),
            // User Information
            ListTile(
                title: Column(children: [
              Text(
                'User',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              GetUserInfo(context, 0)
            ])),
            ListTile(
                title: Column(children: [
              Text(
                'Email',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              GetUserInfo(context, 1)
            ])),
            ListTile(
                title:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                'Content Provided: ',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              GetUserInfo(context, 2)
            ])),
            ListTile(
                title:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                'Scenarios Practiced: ',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              GetUserInfo(context, 3)
            ])),
            // Logout button
            ListTile(
              title: TextButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
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

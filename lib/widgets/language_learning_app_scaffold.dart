import 'package:flutter/material.dart';
import 'package:cs467_language_learning_app/widgets/settings_drawer.dart';

class LanguageLearningAppScaffold extends StatelessWidget {
  const LanguageLearningAppScaffold({
    super.key,
    required this.title,
    required this.child,
    this.backButton,
    required this.subtitle,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final Widget? backButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 25),
              )),
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                subtitle,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              ))
        ]),
        centerTitle: false,
        backgroundColor: Colors.white10,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      endDrawer: SettingsDrawer(),
      body: child,
    );
  }
}

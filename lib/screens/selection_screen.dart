import 'package:language_archive/screens/language_learner_selection_screen.dart';
import 'package:language_archive/screens/content_provider_selection_screen.dart';
import 'package:language_archive/widgets/settings_drawer.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import '../models/userSelection.dart';

class SelectionScreen extends StatefulWidget {
  SelectionScreen({super.key, required this.userCredentials});
  final userCredentials;

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  UserSelection currSelection = UserSelection('empty', 'empty');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text(
              'Welcome!',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 25),
            ),
            automaticallyImplyLeading: false,
            centerTitle: false,
            backgroundColor: Colors.white10,
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 0),
        endDrawer: SettingsDrawer(userInfo: widget.userCredentials),
        body: _selectionScreenDisplay());
  }

  Widget _selectionScreenDisplay() {
    return Center(
        child: ListView(children: [
      ListTile(
          title: Container(
              margin: const EdgeInsets.only(
                  left: 20, right: 20, top: 80, bottom: 80),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.black),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Get user's language choice:
                  const Text(
                    'Select a language to focus on:',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                  GroupButton(
                      isRadio: true,
                      onSelected: (value, index, isSelected) {
                        currSelection.language = value;
                      },
                      buttons: [
                        'Arabic',
                        'Chinese',
                        'English',
                        'French',
                        'Spanish'
                      ],
                      options: GroupButtonOptions(
                          unselectedTextStyle: TextStyle(color: Colors.white),
                          unselectedColor: Colors.black,
                          unselectedBorderColor: Colors.white,
                          selectedTextStyle: TextStyle(color: Colors.black),
                          selectedColor: Colors.white,
                          selectedBorderColor: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          buttonWidth: 100,
                          runSpacing: 0)),
                  SizedBox(height: 30),
                  // Get user's focus choice (user chooses to be a LL or CP):
                  const Text(
                    'What would you like to do today?',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  GroupButton(
                      isRadio: true,
                      onSelected: (value, index, isSelected) {
                        currSelection.role = value;
                      },
                      buttons: ['I want to learn', 'I want to contribute'],
                      options: GroupButtonOptions(
                          unselectedTextStyle: TextStyle(color: Colors.white),
                          unselectedColor: Colors.black,
                          unselectedBorderColor: Colors.white,
                          selectedTextStyle: TextStyle(color: Colors.black),
                          selectedColor: Colors.white,
                          selectedBorderColor: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          buttonWidth: 150,
                          runSpacing: 0)),
                  SizedBox(height: 30),
                  Divider(
                    color: Colors.white,
                    height: 5,
                    thickness: 1,
                    indent: 15,
                    endIndent: 15,
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green),
                      onPressed: () {
                        if (currSelection.validateSelection()) {
                          if (currSelection.role == 'I want to learn') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) =>
                                      LanguageLearnerSelectionScreen(
                                        userSelection: currSelection,
                                        userInfo: widget.userCredentials,
                                      ))),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) =>
                                      ContentProviderSelectionScreen(
                                        userSelection: currSelection,
                                        userInfo: widget.userCredentials,
                                      ))),
                            );
                          }
                        } else {
                          final incorrect = const SnackBar(
                            content: Text(
                              'Please select a language and focus to proceed.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                            duration: const Duration(milliseconds: 2000),
                            backgroundColor: Colors.red,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(incorrect);
                        }
                      },
                      child: const Text('Go')),
                ],
              )))
    ]));
  }
}

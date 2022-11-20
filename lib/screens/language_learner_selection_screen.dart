import 'package:cs467_language_learning_app/models/userSelection.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'language_learner_scenario_screen.dart';
import 'package:cs467_language_learning_app/widgets/language_learning_app_scaffold.dart';
import 'package:cs467_language_learning_app/models/scenario.dart';

class LanguageLearnerSelectionScreen extends StatefulWidget {
  LanguageLearnerSelectionScreen(
      {super.key, required this.userSelection, required this.userInfo});
  UserSelection userSelection;
  final userInfo;

  @override
  State<LanguageLearnerSelectionScreen> createState() =>
      _LanguageLearnerSelectionScreenState();
}

class _LanguageLearnerSelectionScreenState
    extends State<LanguageLearnerSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('scenarios')
          .where('isComplete', isEqualTo: true)
          .where('language', isEqualTo: '${widget.userSelection.language}')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          return LanguageLearningAppScaffold(
            title: 'Learn',
            subtitle: 'Practice a Scenario',
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var entry = snapshot.data!.docs[index];
                Scenario scenario = Scenario(
                    imageURL: entry['imageURL'],
                    language: entry['language'],
                    prompt: entry['prompt'],
                    answer: entry['answer'],
                    translatedAnswer: entry['translatedAnswer'],
                    translatedPrompt: entry['translatedPrompt'],
                    answerAudioUrl: entry['answerAudioUrl'],
                    promptAudioUrl: entry['promptAudioUrl'],
                    isComplete: entry['isComplete']);
                return ListTile(
                  title: Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.black),
                    child: Column(children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text('${scenario.translatedPrompt}',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white))),
                      SizedBox(height: 10),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.white),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          LanguageLearnerScenarioScreen(
                                              scenario: scenario,
                                              userInfo: widget.userInfo))),
                                );
                              },
                              child: const Text('View')))
                    ]),
                  ),
                );
              },
            ),
            userInfo: widget.userInfo,
          );
        } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
          return LanguageLearningAppScaffold(
            title: 'Learn',
            subtitle: 'Practice a Scenario',
            child: Center(
                child: Icon(
              Icons.school,
              size: 120.0,
            )),
            userInfo: widget.userInfo,
          );
        } else {
          return LanguageLearningAppScaffold(
            title: 'Learn',
            subtitle: 'Practice a Scenario',
            child: Center(child: CircularProgressIndicator()),
            userInfo: widget.userInfo,
          );
        }
      },
    );
  }
}

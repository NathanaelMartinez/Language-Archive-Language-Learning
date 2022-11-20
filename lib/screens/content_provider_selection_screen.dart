import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/userSelection.dart';
import 'content_provider_scenario_screen.dart';
import 'package:cs467_language_learning_app/widgets/language_learning_app_scaffold.dart';
import 'package:cs467_language_learning_app/models/scenario.dart';

class ContentProviderSelectionScreen extends StatefulWidget {
  ContentProviderSelectionScreen(
      {super.key, required this.userSelection, required this.userInfo});
  UserSelection userSelection;
  final userInfo;

  @override
  State<ContentProviderSelectionScreen> createState() =>
      _ContentProviderSelectionScreenState();
}

class _ContentProviderSelectionScreenState
    extends State<ContentProviderSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('scenarios')
          .where('isComplete', isEqualTo: false)
          .where('language', isEqualTo: '${widget.userSelection.language}')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          return LanguageLearningAppScaffold(
            title: 'Contribute',
            subtitle: 'Help Answer a Scenario',
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
                    isComplete: entry['isComplete'],
                    docRef: entry.id);
                return ListTile(
                  title: Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.black),
                    child: Column(
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text('${scenario.prompt}',
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
                                onPressed: () async {
                                  bool result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: ((context) =>
                                          ContentProviderScenarioScreen(
                                            scenario: scenario,
                                            userInfo: widget.userInfo,
                                          )),
                                    ),
                                  );
                                  if (result == true) {
                                    final submitSuccess = const SnackBar(
                                      content: Text(
                                        'Submission success! Thanks for your contribution!.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      duration:
                                          const Duration(milliseconds: 2000),
                                      backgroundColor: Colors.green,
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        submitSuccess); //Show SnackBar
                                  }
                                },
                                child: const Text('View')))
                      ],
                    ),
                  ),
                );
              },
            ),
            userInfo: widget.userInfo,
          );
        } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
          return LanguageLearningAppScaffold(
            title: 'Contribute',
            subtitle: 'Help Answer a Scenario',
            child: Center(
                child: Icon(
              Icons.school,
              size: 120.0,
            )),
            userInfo: widget.userInfo,
          );
        } else {
          return LanguageLearningAppScaffold(
            title: 'Contribute',
            subtitle: 'Help Answer a Scenario',
            child: Center(child: CircularProgressIndicator()),
            userInfo: widget.userInfo,
          );
        }
      },
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:cs467_language_learning_app/widgets/language_learning_app_scaffold.dart';
import '../models/scenario.dart';

class LanguageLearnerScenarioScreen extends StatefulWidget {
  LanguageLearnerScenarioScreen({super.key, required this.scenario, required this.userInfo});
  Scenario scenario;
  final userInfo;

  @override
  State<LanguageLearnerScenarioScreen> createState() =>
      _LanguageLearnerScenarioScreenState();
}

class _LanguageLearnerScenarioScreenState
    extends State<LanguageLearnerScenarioScreen> {
  // Development testing ----------
  bool _isListening = false;
  var _speechToText = SpeechToText();
  // ------------------------------
  var userAnswer = '';
  var userAnswerController = TextEditingController();

  void listen() async {
    if (!_isListening)  {
      bool available = await _speechToText.initialize(
        onStatus: (status) => print("$status"),
        onError: (errorNotification) => print("$errorNotification"),
      );
      if (available)  {
        setState(() {
          _isListening = true;
        });
        _speechToText.listen(
          onResult: (result) => setState(() {
            userAnswerController.text = result.recognizedWords;
          }),
        );
      }
    } else  {
      setState(() {
        _isListening = false;
      });
      _speechToText.stop();
    }
  }

  @override
  void initState()  {
    super.initState();
    _speechToText = SpeechToText();
  }

  @override
  void dispose()  {
    userAnswerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LanguageLearningAppScaffold(
        title: '${widget.scenario.translatedPrompt}',
        child: _languageLearnerScenarioDisplay(),
        subtitle: '${widget.scenario.language}',
        userInfo: widget.userInfo,
        );
  }

  Widget _languageLearnerScenarioDisplay() {
    return Center(
      child: ListView(children: [
        ListTile(
            title: Container(
          padding: const EdgeInsets.all(25),
          child: Column(children: [
            // Image Group
            Image.network(
              widget.scenario.imageURL,
              scale: 1.0,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                    color: Colors.black,
                  ),
                );
              },
            ),
            SizedBox(height: 30),
            // Prompt Group
            Column(
              children: [
                Text(
                  'Prompt',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '${widget.scenario.translatedPrompt}',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Answer',
                      hintText: 'Please enter the prompt\'s answer'),
                  controller: userAnswerController,
                ),
                SizedBox(height: 5),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black),
                  onPressed: () {
                    listen();
                  },
                  child: Text(_isListening ? 'Recording...' : 'Record Answer')),
              ],
            ),
            // Button Group
            SizedBox(height: 30),
            Divider(
              color: Colors.black,
              height: 5,
              thickness: 1,
              indent: 15,
              endIndent: 15,
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green),
                    onPressed: () {
                      if (userAnswerController.text == '') {
                        final missingInput = const SnackBar(
                          content: Text(
                            'Please input answer.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                          duration: const Duration(milliseconds: 2000),
                          backgroundColor: Colors.red,
                        );
                        ScaffoldMessenger.of(context)
                            .showSnackBar(missingInput);
                      } else {
                        if (userAnswerController.text ==
                            widget.scenario.translatedAnswer) {
                          final correctInput = const SnackBar(
                            content: Text(
                              'Correct!',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                            duration: const Duration(milliseconds: 2000),
                            backgroundColor: Colors.green,
                          );
                          ScaffoldMessenger.of(context)
                              .showSnackBar(correctInput);
                        } else {
                          final incorrectInput = const SnackBar(
                            content: Text(
                              'Inocrrect - please try again.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                            duration: const Duration(milliseconds: 2000),
                            backgroundColor: Colors.red,
                          );
                          ScaffoldMessenger.of(context)
                              .showSnackBar(incorrectInput);
                        }
                      }
                    },
                    child: Text('Submit')),
                SizedBox(width: 10),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        side: BorderSide(color: Colors.blue),
                        foregroundColor: Colors.blue,
                        backgroundColor: Colors.white),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: const Text('Scenario Answer',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700)),
                                content: SingleChildScrollView(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text('Prompt:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700)),
                                        Text(
                                            '${widget.scenario.translatedPrompt}'),
                                        SizedBox(height: 10),
                                        const Text('Translated Prompt:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700)),
                                        Text('${widget.scenario.prompt}'),
                                        SizedBox(height: 20),
                                        const Text('Answer:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700)),
                                        Text(
                                            '${widget.scenario.translatedAnswer}'),
                                        SizedBox(height: 10),
                                        const Text('Translated Answer:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700)),
                                        Text('${widget.scenario.answer}'),
                                      ]),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Go Back'),
                                  ),
                                ],
                              ));
                    },
                    child: const Text('Show Answer'))
              ],
            )
          ]),
        )),
      ]),
    );
  }

  Future<void> _updateUserLLCount() async {
    var db = FirebaseFirestore.instance;
    db.collection('users').where('uid', isEqualTo: widget.userInfo.user.uid.toString()).get().then(
      (res) {
        var newLLCount = res.docs[0]['llPoints'] + 1;
        db.collection('users').doc(res.docs[0].id).update({'llPoints' : newLLCount});
      },
      onError: (e) => print('Error retrieving user: $e'),
    );
  }
}

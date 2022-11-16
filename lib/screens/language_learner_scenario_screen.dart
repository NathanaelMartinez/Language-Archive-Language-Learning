import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cs467_language_learning_app/widgets/language_learning_app_scaffold.dart';
import '../models/scenario.dart';
import '../widgets/text_controller.dart';

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
  var userAnswer = '';
  var userAnswerController = TextControllerState();

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
                  controller: userAnswerController.formControler,
                ),
                SizedBox(height: 5),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black),
                    // TODO: Input audio recording feature
                    onPressed: () {},
                    child: Text('Record Answer')),
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
                      if (userAnswerController.formControler.text == '') {
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
                        if (userAnswerController.formControler.text ==
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
}

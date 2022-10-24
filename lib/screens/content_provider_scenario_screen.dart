import 'package:cs467_language_learning_app/models/scenario.dart';
import 'package:flutter/material.dart';
import 'package:cs467_language_learning_app/widgets/language_learning_app_scaffold.dart';
import 'package:cs467_language_learning_app/widgets/text_controller.dart';

class ContentProviderScenarioScreen extends StatefulWidget {
  ContentProviderScenarioScreen({super.key, required this.scenario});
  Scenario scenario;

  @override
  State<ContentProviderScenarioScreen> createState() =>
      _ContentProviderScenarioScreenState();
}

class _ContentProviderScenarioScreenState
    extends State<ContentProviderScenarioScreen> {
  var textPromptTranslation = '';
  var textAnswerTranslation = '';
  var textPromptController = TextControllerState();
  var textAnswerController = TextControllerState();

  @override
  Widget build(BuildContext context) {
    return LanguageLearningAppScaffold(
        title: '${widget.scenario.prompt}',
        child: _contentProviderScenarioDisplay(),
        subtitle: '${widget.scenario.language}');
  }

  Widget _contentProviderScenarioDisplay() {
    return Center(
      child: ListView(children: [
        ListTile(
            title: Container(
          padding: const EdgeInsets.all(25),
          child: Column(children: [
            // Image Group
            // TODO: Change to actual image
            SizedBox(height: 25),
            const Icon(
              Icons.image,
              size: 130.0,
              color: Colors.black,
            ),
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
                  '${widget.scenario.prompt}',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Prompt Translation',
                      hintText:
                          'Please enter the ${widget.scenario.language} translation'),
                  controller: textPromptController.formControler,
                ),
                SizedBox(height: 5),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black),
                    // TODO: Input audio recording feature
                    onPressed: () {},
                    child: Text('Record Translation')),
              ],
            ),
            SizedBox(height: 15),
            // Answer Group
            Column(
              children: [
                Text(
                  'Answer',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '${widget.scenario.answer}',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Answer Translation',
                      hintText:
                          'Please enter the ${widget.scenario.language} translation'),
                  controller: textAnswerController.formControler,
                ),
                SizedBox(height: 5),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black),
                    // TODO: Input audio recording feature
                    onPressed: () {},
                    child: Text('Record Translation')),
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
                      if (textAnswerController.formControler.text == '' ||
                          textPromptController.formControler.text == '') {
                        final incorrectInput = const SnackBar(
                          content: Text(
                            'Please input translation for both prompt and answer.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                          duration: const Duration(milliseconds: 2000),
                          backgroundColor: Colors.red,
                        );
                        ScaffoldMessenger.of(context)
                            .showSnackBar(incorrectInput);
                      } else {
                        // TODO: Add database input functionality
                        textAnswerTranslation =
                            textAnswerController.formControler.text;
                        textPromptTranslation =
                            textPromptController.formControler.text;
                      }
                    },
                    child: Text('Submit')),
                SizedBox(width: 10),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        side: BorderSide(color: Colors.red),
                        foregroundColor: Colors.red,
                        backgroundColor: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'))
              ],
            )
          ]),
        )),
      ]),
    );
  }
}

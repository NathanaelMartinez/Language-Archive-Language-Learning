import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:language_archive/widgets/language_learning_app_scaffold.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/scenario.dart';

class LanguageLearnerScenarioScreen extends StatefulWidget {
  LanguageLearnerScenarioScreen(
      {super.key, required this.scenario, required this.userInfo});
  Scenario scenario;
  final userInfo;

  @override
  State<LanguageLearnerScenarioScreen> createState() =>
      _LanguageLearnerScenarioScreenState();
}

class _LanguageLearnerScenarioScreenState
    extends State<LanguageLearnerScenarioScreen> {
  bool _isListening = false;
  bool _isPlaying = false;
  final player = FlutterSoundPlayer();
  var _speechToText = SpeechToText();
  var locales;
  var userAnswer = '';
  var userAnswerController = TextEditingController();

  Future<String> getLocales(List<LocaleName> availableLocales) async {
    var selectedLocale;
    int count = 0;

    switch (widget.scenario.language) {
      case 'Arabic':
        {
          while (availableLocales[count].localeId != 'ar_AE') {
            count++;
          }
          selectedLocale = availableLocales[count].localeId;
          count = 0;
          return selectedLocale;
        }
      case 'Chinese':
        {
          while (availableLocales[count].localeId != 'cmn_CN') {
            count++;
          }
          selectedLocale = availableLocales[count].localeId;
          count = 0;
          return selectedLocale;
        }
      case 'French':
        {
          while (availableLocales[count].localeId != 'fr_FR') {
            count++;
          }
          selectedLocale = availableLocales[count].localeId;
          count = 0;
          return selectedLocale;
        }
      case 'Spanish':
        {
          while (availableLocales[count].localeId != 'es_MX') {
            count++;
          }
          selectedLocale = availableLocales[count].localeId;
          count = 0;
          return selectedLocale;
        }
      default:
        {
          while (availableLocales[count].localeId != 'en_US') {
            count++;
          }
          selectedLocale = availableLocales[count].localeId;
          count = 0;
          return selectedLocale;
        }
    }
  }

  void _startPlayback(String audioURL) async {
    if (!_isPlaying) {
      _isPlaying = true;
      await player.openPlayer();
      await player.startPlayer(
        fromURI: audioURL,
        codec: Codec.aacMP4,
        whenFinished: () => setState(() {
          _isPlaying = false;
        }),
      );
    } else {
      await player.stopPlayer();
      await player.closePlayer();
      _isPlaying = false;
    }
    setState(() {});
  }

  void listen() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize(
        onStatus: (status) => print("$status"),
        onError: (errorNotification) => print("$errorNotification"),
      );
      if (available) {
        locales = await _speechToText.locales();
        var selected = await getLocales(locales);
        setState(() {
          _isListening = true;
        });
        _speechToText.listen(
          onResult: (result) => setState(() {
            userAnswerController.text = result.recognizedWords;
          }),
          localeId: selected,
        );
      }
    } else {
      setState(() {
        _isListening = false;
      });
      _speechToText.stop();
    }
  }

  Future<String> getTranslator() async {
    var db = FirebaseFirestore.instance;
    var doc =
        await db.collection('scenarios').doc(widget.scenario.docRef).get();
    return doc.data().toString().contains('translator')
        ? doc.get('translator')
        : '';
  }

  Future<bool> recordingPermissions() async {
    var status = await Permission.microphone.request();
    return status.isGranted ? true : false;
  }

  @override
  void initState() {
    super.initState();
    _speechToText = SpeechToText();
  }

  @override
  void dispose() {
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
      child: ListView(
        children: [
          ListTile(
            title: Container(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
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
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
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
                      FutureBuilder<bool>(
                          future: recordingPermissions(),
                          builder: (BuildContext context,
                              AsyncSnapshot<bool> snapshot) {
                            if (snapshot.data == false) {
                              return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.grey),
                                  onPressed: () {
                                    null;
                                  },
                                  child: Text('Enable Microphone Permissions'));
                            } else {
                              return GestureDetector(
                                onLongPressStart: (details) {
                                  listen();
                                },
                                onLongPressUp: () {
                                  setState(() {
                                    _isListening = false;
                                    _speechToText.stop();
                                  });
                                },
                                child: speechToTextButtonGroup(_isListening),
                              );
                            }
                          }),
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
                        onPressed: () async {
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
                            bool result = await checkUserAnswer(
                                userAnswerController.text);
                            if (result) {
                              final correctInput = const SnackBar(
                                content: Text(
                                  'Correct!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                                duration: const Duration(milliseconds: 2000),
                                backgroundColor: Colors.green,
                              );
                              await _updateUserLLCount();
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
                        child: Text('Submit'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          side: BorderSide(color: Colors.blue),
                          foregroundColor: Colors.blue,
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text(
                                'Scenario Answer',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              content: SingleChildScrollView(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Prompt:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        '${widget.scenario.translatedPrompt}',
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: Colors.green,
                                        ),
                                        child: Text('Play Prompt'),
                                        onPressed: () {
                                          _startPlayback(
                                              widget.scenario.promptAudioUrl);
                                        },
                                      ),
                                      SizedBox(height: 10),
                                      const Text(
                                        'Translated Prompt:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text('${widget.scenario.prompt}'),
                                      SizedBox(height: 20),
                                      const Text(
                                        'Answer:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Text(
                                        '${widget.scenario.translatedAnswer}',
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: Colors.green,
                                        ),
                                        child: Text('Play Answer'),
                                        onPressed: () {
                                          _startPlayback(
                                            widget.scenario.answerAudioUrl,
                                          );
                                        },
                                      ),
                                      SizedBox(height: 10),
                                      const Text(
                                        'Translated Answer:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text('${widget.scenario.answer}'),
                                    ]),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Go Back'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text('Show Answer'),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  FutureBuilder<String>(
                    future: getTranslator(),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.data == "") {
                        return Text(
                            'The scenario translator could not be loaded in at this time.',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w300));
                      } else {
                        return Text(
                          'Translation provided by: ${snapshot.data}',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w300),
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> checkUserAnswer(String userAnswer) async {
    var comparison =
        (widget.scenario.translatedAnswer).similarityTo(userAnswer);
    return comparison >= 0.75 ? true : false;
  }

  Widget speechToTextButtonGroup(bool isRecording) {
    if (isRecording) {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.green),
          onPressed: () {
            _isListening = false;
            _speechToText.stop();
          },
          child: Text('Recording...'));
    } else {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.black),
          onPressed: () {},
          child: Text('Hold to Record Answer'));
    }
  }

  Future<void> _updateUserLLCount() async {
    var db = FirebaseFirestore.instance;
    db
        .collection('users')
        .where('uid', isEqualTo: widget.userInfo.user.uid.toString())
        .get()
        .then(
      (res) {
        var newLLCount = res.docs[0]['llPoints'] + 1;
        db
            .collection('users')
            .doc(res.docs[0].id)
            .update({'llPoints': newLLCount});
      },
      onError: (e) => print('Error retrieving user: $e'),
    );
  }
}

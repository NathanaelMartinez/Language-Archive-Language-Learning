import 'dart:io';
import 'package:language_archive/models/scenarioDTO.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

import 'package:language_archive/models/scenario.dart';
import 'package:language_archive/widgets/language_learning_app_scaffold.dart';

class ContentProviderScenarioScreen extends StatefulWidget {
  ContentProviderScenarioScreen(
      {super.key, required this.scenario, required this.userInfo});
  final Scenario scenario;
  final userInfo;

  @override
  State<ContentProviderScenarioScreen> createState() =>
      _ContentProviderScenarioScreenState();
}

class _ContentProviderScenarioScreenState
    extends State<ContentProviderScenarioScreen> {
  var textPromptTranslation = '';
  var textAnswerTranslation = '';
  var textPromptController = TextEditingController();
  var textAnswerController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final recorder = FlutterSoundRecorder();
  final player = FlutterSoundPlayer();
  ScenarioDTO scenarioDTO = ScenarioDTO();
  late bool _isUploading;
  late bool _isPromptRecorded;
  late bool _isAnswerRecorded;
  late bool _isRecordingPrompt;
  late bool _isRecordingAnswer;
  late bool _isPlayingPrompt;
  late bool _isPlayingAnswer;

  File? promptAudio;
  File? answerAudio;
  String? recordedUrl;
  String? promptAudioUrl;
  String? answerAudioUrl;

  @override
  void initState() {
    super.initState();
    _isUploading = false;
    _isPromptRecorded = false;
    _isAnswerRecorded = false;
    _isRecordingPrompt = false;
    _isRecordingAnswer = false;
    _isPlayingPrompt = false;
    _isPlayingAnswer = false;
  }

  @override
  void dispose() {
    textPromptController.dispose();
    textAnswerController.dispose();
    super.dispose();
  }

  _startRecord({required String audioType}) async {
    PermissionStatus status = await Permission.microphone.request();
    await Permission.microphone.request();
    if (status != PermissionStatus.granted)
      throw RecordingPermissionException("Microphone permission not granted");
    await recorder.openRecorder();
    Directory directory = await getApplicationDocumentsDirectory();
    String filepath = directory.path +
        '/' +
        DateTime.now().millisecondsSinceEpoch.toString() +
        '.mp4';
    await recorder.startRecorder(
      toFile: filepath,
      codec: Codec.aacMP4,
    );
    setState(() {
      if (audioType == 'Prompt') {
        _isRecordingPrompt = true;
      } else {
        _isRecordingAnswer = true;
      }
    });
  }

  _stopRecord({required String audioType}) async {
    await recorder.stopRecorder().then((value) {
      recordedUrl = value;
      setState(() {
        debugPrint('PATH : -------- $recordedUrl');
        if (audioType == 'Prompt') {
          _isPromptRecorded = true;
          promptAudioUrl = recordedUrl;
        } else {
          _isAnswerRecorded = true;
          answerAudioUrl = recordedUrl;
        }
        recorder.closeRecorder();
        _isRecordingPrompt = false;
        _isRecordingAnswer = false;
      });
    });
  }

  _startPlayback(audioURL, audioType) async {
    if (audioType == 'Prompt') {
      if (!_isPlayingPrompt) {
        _isPlayingPrompt = true;
        await player.openPlayer();
        await player.startPlayer(
          fromURI: audioURL,
          codec: Codec.aacMP4,
          whenFinished: () => setState(() {
            _isPlayingPrompt = false;
          }),
        );
      } else {
        await player.stopPlayer();
        await player.closePlayer();
        _isPlayingPrompt = false;
      }
      setState(() {});
    } else if (audioType == 'Answer') {
      if (!_isPlayingAnswer) {
        _isPlayingAnswer = true;
        await player.openPlayer();
        await player.startPlayer(
          fromURI: audioURL,
          codec: Codec.aacMP4,
          whenFinished: () => setState(() {
            _isPlayingAnswer = false;
          }),
        );
      } else {
        await player.stopPlayer();
        await player.closePlayer();
        _isPlayingAnswer = false;
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return LanguageLearningAppScaffold(
      title: '${widget.scenario.prompt}',
      child: _contentProviderScenarioDisplay(),
      subtitle: '${widget.scenario.language}',
      userInfo: widget.userInfo,
    );
  }

  Widget _contentProviderScenarioDisplay() {
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
                        '${widget.scenario.prompt}',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Prompt Translation',
                            hintText:
                                'Please enter the ${widget.scenario.language} translation'),
                        controller: textPromptController,
                      ),
                      SizedBox(height: 5),
                      GestureDetector(
                        onLongPressStart: (details) {
                          _startRecord(
                            audioType: 'Prompt',
                          ); // start recording when long pressed
                        },
                        onLongPressUp: () {
                          _stopRecord(
                            audioType: 'Prompt',
                          ); // stop recording when released
                        },
                        child: recordOrRecordedPrompt(audioType: 'Prompt'),
                      )
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
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Answer Translation',
                            hintText:
                                'Please enter the ${widget.scenario.language} translation'),
                        controller: textAnswerController,
                      ),
                      SizedBox(height: 5),
                      GestureDetector(
                        onLongPressStart: (details) {
                          _startRecord(
                            audioType: 'Answer',
                          ); // start recording when long pressed
                        },
                        onLongPressUp: () {
                          _stopRecord(
                            audioType: 'Answer',
                          ); // stop recording when released
                        },
                        child: recordOrRecordedAnswer(audioType: 'Answer'),
                      )
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
                          debugPrint('$scenarioDTO');
                          if (textAnswerController.text == '' ||
                              textPromptController.text == '' ||
                              answerAudioUrl == null ||
                              promptAudioUrl == null ||
                              answerAudioUrl == '' ||
                              promptAudioUrl == '') {
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
                            scenarioDTO.translatedAnswer =
                                textAnswerController.text;
                            scenarioDTO.translatedPrompt =
                                textPromptController.text;
                            await _uploadAudioFiles();
                            scenarioDTO.isComplete = true;
                            String userTranslator = await _getUserName();
                            scenarioDTO.translator = userTranslator;
                            FirebaseFirestore.instance
                                .collection('scenarios')
                                .doc(widget.scenario.docRef)
                                .update(scenarioDTO.toMap());
                            await _updateUserCPCount();
                            Navigator.of(context).pop(true);
                          }
                        },
                        child: Text('Submit'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            side: BorderSide(color: Colors.red),
                            foregroundColor: Colors.red,
                            backgroundColor: Colors.white),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text('Cancel'),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String> _getUserName() async {
    var db = FirebaseFirestore.instance;
    var doc = await db
        .collection('users')
        .where('uid', isEqualTo: widget.userInfo.user.uid.toString())
        .get();
    return doc.docs[0]['name'];
  }

  Future<void> _updateUserCPCount() async {
    var db = FirebaseFirestore.instance;
    db
        .collection('users')
        .where('uid', isEqualTo: widget.userInfo.user.uid.toString())
        .get()
        .then(
      (res) {
        var newCPCount = res.docs[0]['cpPoints'] + 1;
        db
            .collection('users')
            .doc(res.docs[0].id)
            .update({'cpPoints': newCPCount});
      },
      onError: (e) => print('Error retrieving user: $e'),
    );
  }

  Future<void> _uploadAudioFiles() async {
    setState(() {
      _isUploading = true;
    });
    try {
      promptAudio = File(promptAudioUrl!);
      var fileName =
          '${DateTime.now()}-${widget.scenario.language}-${widget.scenario.prompt}-prompt.mp4';
      Reference storageReference =
          FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = storageReference.putFile(promptAudio!);
      await uploadTask;
      scenarioDTO.promptAudioUrl = await storageReference.getDownloadURL();
      debugPrint('PROMPT URL -------------- ${scenarioDTO.promptAudioUrl}');

      answerAudio = File(answerAudioUrl!);
      fileName =
          '${DateTime.now()}-${widget.scenario.language}-${widget.scenario.answer}-answer.mp4';
      storageReference = FirebaseStorage.instance.ref().child(fileName);
      uploadTask = storageReference.putFile(answerAudio!);
      await uploadTask;
      scenarioDTO.answerAudioUrl = await storageReference.getDownloadURL();
      debugPrint('ANSWER URL -------------- ${scenarioDTO.answerAudioUrl}');
    } catch (error) {
      print('Error occured while uplaoding to Firebase ${error.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error occured while uploading audio',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          duration: const Duration(milliseconds: 2000),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      _isUploading = false;
    }
  }

  Widget recordOrRecordedPrompt({required String audioType}) {
    if (_isRecordingPrompt) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.green),
        onPressed: () {},
        child: Text('Recording...'),
      );
    } else if (audioType == 'Prompt' && _isPromptRecorded) {
      return Row(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
            ),
            child: stopOrPlay(_isPlayingPrompt),
            onPressed: () {
              _startPlayback(
                promptAudioUrl,
                audioType,
              );
              setState(() {});
            },
          ),
          SizedBox(
            width: 20,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                side: BorderSide(color: Colors.red),
                foregroundColor: Colors.red,
                backgroundColor: Colors.white),
            child: Icon(Icons.cancel_outlined),
            onPressed: () => setState(
              () {
                _isPromptRecorded = false;
                promptAudioUrl = '';
              },
            ),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      );
    } else {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.black),
        onPressed: () {},
        child: Text('Hold to Record $audioType'),
      );
    }
  }

  Widget recordOrRecordedAnswer({required String audioType}) {
    if (_isRecordingAnswer) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.green),
        onPressed: () {},
        child: Text('Recording...'),
      );
    } else if (audioType == 'Answer' && _isAnswerRecorded) {
      return Row(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
            ),
            child: stopOrPlay(_isPlayingAnswer),
            onPressed: () {
              _startPlayback(
                answerAudioUrl,
                audioType,
              );
              setState(() {});
            },
          ),
          SizedBox(
            width: 20,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                side: BorderSide(color: Colors.red),
                foregroundColor: Colors.red,
                backgroundColor: Colors.white),
            child: Icon(Icons.cancel_outlined),
            onPressed: () => setState(
              () {
                _isAnswerRecorded = false;
                answerAudioUrl = '';
              },
            ),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      );
    } else {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.black),
        onPressed: () {},
        child: Text('Hold to Record $audioType'),
      );
    }
  }

  Widget stopOrPlay(nowPlaying) {
    if (nowPlaying) {
      return Text('Stop Recording');
    } else {
      return Text('Play Recording');
    }
  }
}

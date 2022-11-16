import 'dart:io';
import 'package:cs467_language_learning_app/models/scenarioDTO.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:cs467_language_learning_app/models/scenario.dart';
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
  final formKey = GlobalKey<FormState>();
  final recorder = FlutterSoundRecorder();
  final player = FlutterSoundPlayer();
  ScenarioDTO scenarioDTO = ScenarioDTO();
  late bool _isUploading;
  late bool _isPromptRecorded;
  late bool _isAnswerRecorded;
  late bool _isRecording;
  late bool _isPlaying;

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
    _isRecording = false;
    _isPlaying = false;
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    super.dispose();
  }

  _startRecord({required String audioType}) async {
    PermissionStatus status = await Permission.microphone.request();
    await Permission.microphone.request();
    if (status != PermissionStatus.granted)
      throw RecordingPermissionException("Microphone permission not granted");
    await recorder.openRecorder();
    _isRecording = false;
    Directory directory = await getApplicationDocumentsDirectory();
    String filepath = directory.path +
        '/' +
        DateTime.now().millisecondsSinceEpoch.toString() +
        '.mp4';
    await recorder.startRecorder(
      toFile: filepath,
      codec: Codec.aacMP4,
    );
  }

  _stopRecord({required String audioType}) async {
    await recorder.stopRecorder().then((value) {
      recordedUrl = value;
      setState(() {
        debugPrint('PATH : -------- $recordedUrl');
        if (audioType == 'prompt') {
          _isPromptRecorded = true;
          promptAudioUrl = recordedUrl;
        } else {
          _isAnswerRecorded = true;
          answerAudioUrl = recordedUrl;
        }
        recorder.closeRecorder();
      });
    });
  }

  _startPlayback(audioURL) async {
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
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LanguageLearningAppScaffold(
        title: '${widget.scenario.prompt}',
        child: _contentProviderScenarioDisplay(),
        subtitle: '${widget.scenario.language}');
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
                        controller: textPromptController.formControler,
                      ),
                      SizedBox(height: 5),
                      GestureDetector(
                        onLongPressStart: (details) {
                          _startRecord(
                            audioType: 'prompt',
                          ); // start recording when long pressed
                        },
                        onLongPressUp: () {
                          _stopRecord(
                            audioType: 'prompt',
                          ); // stop recording when released
                        },
                        child: recordOrRecorded(audioType: 'prompt'),
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
                        controller: textAnswerController.formControler,
                      ),
                      SizedBox(height: 5),
                      GestureDetector(
                        onLongPressStart: (details) {
                          _startRecord(
                            audioType: 'answer',
                          ); // start recording when long pressed
                        },
                        onLongPressUp: () {
                          _stopRecord(
                            audioType: 'answer',
                          ); // stop recording when released
                        },
                        child: recordOrRecorded(audioType: 'answer'),
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
                          if (textAnswerController.formControler.text == '' ||
                              textPromptController.formControler.text == '' ||
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
                                textAnswerController.formControler.text;
                            scenarioDTO.translatedPrompt =
                                textPromptController.formControler.text;
                            await _uploadAudioFiles();
                            scenarioDTO.isComplete = true;
                            FirebaseFirestore.instance
                                .collection('scenarios')
                                .doc(widget.scenario.docRef)
                                .update(scenarioDTO.toMap());
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

      // widget.onUploadComplete();
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

  recordOrRecorded({required String audioType}) {
    if (audioType == 'prompt' && _isPromptRecorded) {
      return Row(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
            ),
            child: Icon(Icons.play_arrow),
            onPressed: () {
              _startPlayback(promptAudioUrl);
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
    } else if (audioType == 'answer' && _isAnswerRecorded) {
      return Row(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
            ),
            child: Icon(Icons.play_arrow),
            onPressed: () {
              _startPlayback(answerAudioUrl);
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
        child: Text('Hold to record $audioType'),
      );
    }
  }
}

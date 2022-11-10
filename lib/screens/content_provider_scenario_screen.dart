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
  ScenarioDTO scenarioDTO = ScenarioDTO();
  late bool _isUploading;
  late bool _isRecorded;
  late bool _isRecording;

  File? promptAudio;
  File? answerAudio;
  String? recordedUrl;

  Codec _codec = Codec.defaultCodec;

  @override
  void initState() {
    super.initState();
    initializer();
  }

  void initializer() async {
    _isUploading = false;
    _isRecorded = false;
    _isRecording = false;
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
    _isRecorded = true;
    Directory directory = await getApplicationDocumentsDirectory();
    String filepath = directory.path +
        '/' +
        DateTime.now().millisecondsSinceEpoch.toString() +
        '.aac';
    await recorder.startRecorder(
      toFile: 'audio',
      codec: _codec,
    );
  }

  _stopRecord({required String audioType}) async {
    await recorder.stopRecorder().then((value) {
      setState(() {
        //var url = value;
        recordedUrl = value;
        debugPrint('path : -------- $recordedUrl');
        _isRecorded = true;
        if (audioType == 'prompt') {
          scenarioDTO.promptAudioUrl = recordedUrl;
        } else {
          scenarioDTO.answerAudioUrl = recordedUrl;
        }
      });
    });
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
                  GestureDetector(
                    onLongPressStart: (details) {
                      _startRecord(
                          audioType:
                              'prompt'); // start recording when long pressed
                    },
                    onLongPressUp: () {
                      _stopRecord(
                          audioType: 'prompt'); // stop recording when released
                      debugPrint('path : -------- $recordedUrl');
                    },
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black),
                      // TODO: Input audio recording feature
                      onPressed: () {},
                      child: Text('Hold to Record'),
                    ),
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
                  GestureDetector(
                    onLongPressStart: (details) {
                      _startRecord(
                          audioType:
                              'answer'); // start recording when long pressed
                    },
                    onLongPressUp: () {
                      _stopRecord(
                          audioType: 'answer'); // stop recording when released
                      debugPrint('path : -------- $recordedUrl');
                    },
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black),
                      // TODO: Input audio recording feature
                      onPressed: () {},
                      child: Text('Hold to Record'),
                    ),
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
                          scenarioDTO.translatedAnswer =
                              textAnswerController.formControler.text;
                          scenarioDTO.translatedPrompt =
                              textPromptController.formControler.text;
                          _uploadAudioFiles();
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
                    child: const Text('Cancel'),
                  )
                ],
              )
            ]),
          ),
        ),
      ]),
    );
  }

  Future<void> _uploadAudioFiles() async {
    setState(() {
      _isUploading = true;
    });
    try {
      promptAudio = File(scenarioDTO.promptAudioUrl!);
      var fileName = '${DateTime.now()}Prompt.aac';
      Reference storageReference =
          FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = storageReference.putFile(promptAudio!);
      await uploadTask;
      scenarioDTO.promptAudioUrl = await storageReference.getDownloadURL();
      answerAudio = File(scenarioDTO.answerAudioUrl!);
      fileName = '${DateTime.now()}Answer.aac';
      storageReference = FirebaseStorage.instance.ref().child(fileName);
      uploadTask = storageReference.putFile(answerAudio!);
      await uploadTask;
      scenarioDTO.answerAudioUrl = await storageReference.getDownloadURL();
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
      setState(() {
        _isUploading = false;
      });
    }
  }
}

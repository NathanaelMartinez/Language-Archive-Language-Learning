import 'package:flutter/material.dart';
import 'package:cs467_language_learning_app/widgets/language_learning_app_scaffold.dart';

class LanguageLearnerScenarioScreen extends StatefulWidget {
  @override
  State<LanguageLearnerScenarioScreen> createState() =>
      _LanguageLearnerScenarioScreenState();
}

class _LanguageLearnerScenarioScreenState
    extends State<LanguageLearnerScenarioScreen> {
  @override
  Widget build(BuildContext context) {
    return LanguageLearningAppScaffold(
        title: 'Scenario',
        child: Center(child: Icon(Icons.school)),
        subtitle: 'subtitle');
  }
}

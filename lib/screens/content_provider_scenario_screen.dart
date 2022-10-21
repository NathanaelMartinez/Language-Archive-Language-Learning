import 'package:flutter/material.dart';
import 'package:cs467_language_learning_app/widgets/language_learning_app_scaffold.dart';

class ContentProviderScenarioScreen extends StatefulWidget {
  @override
  State<ContentProviderScenarioScreen> createState() =>
      _ContentProviderScenarioScreenState();
}

class _ContentProviderScenarioScreenState
    extends State<ContentProviderScenarioScreen> {
  @override
  Widget build(BuildContext context) {
    return LanguageLearningAppScaffold(
        title: 'Scenario',
        child: Center(child: Icon(Icons.school)),
        subtitle: 'subtitle');
  }
}

class Scenario {
  String imageURL;
  String language;
  String prompt;
  String answer;
  String translatedAnswer;
  String translatedPrompt;
  bool isComplete;

  Scenario(
      {required this.imageURL,
      required this.language,
      required this.prompt,
      required this.answer,
      required this.translatedAnswer,
      required this.translatedPrompt,
      required this.isComplete});
}

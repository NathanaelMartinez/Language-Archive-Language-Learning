class Scenario {
  String imageURL;
  String language;
  String prompt;
  String answer;
  String translatedAnswer;
  String translatedPrompt;
  String answerAudioUrl;
  String promptAudioUrl;
  String? docRef;
  bool isComplete;

  Scenario(
      {required this.imageURL,
      required this.language,
      required this.prompt,
      required this.answer,
      required this.translatedAnswer,
      required this.translatedPrompt,
      required this.answerAudioUrl,
      required this.promptAudioUrl,
      required this.isComplete,
      this.docRef});
}

class ScenarioDTO {
  String? promptAudioUrl;
  String? answerAudioUrl;
  String? translatedAnswer;
  String? translatedPrompt;
  bool? isComplete;

  ScenarioDTO(
      {this.promptAudioUrl,
      this.answerAudioUrl,
      this.translatedAnswer,
      this.translatedPrompt,
      this.isComplete});
}

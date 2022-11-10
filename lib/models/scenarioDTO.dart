class ScenarioDTO {
  String? promptAudioUrl;
  String? answerAudioUrl;
  String? translatedPrompt;
  String? translatedAnswer;
  bool? isCompleted;

  ScenarioDTO(
      {this.promptAudioUrl,
      this.answerAudioUrl,
      this.translatedPrompt,
      this.translatedAnswer,
      this.isCompleted});

  Map<String, dynamic> toMap() {
    return {
      'promptAudioUrl': promptAudioUrl,
      'answerAudioUrl': answerAudioUrl,
      'translatedPrompt': translatedPrompt,
      'translatedAnswer': translatedAnswer,
      'isCompleted': isCompleted
    };
  }
}

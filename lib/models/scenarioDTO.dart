class ScenarioDTO {
  String? promptAudioUrl;
  String? answerAudioUrl;
  String? translatedPrompt;
  String? translatedAnswer;
  String? translator;
  bool? isComplete;

  ScenarioDTO(
      {this.promptAudioUrl,
      this.answerAudioUrl,
      this.translatedPrompt,
      this.translatedAnswer,
      this.translator,
      this.isComplete});

  Map<String, Object?> toMap() {
    return {
      'promptAudioUrl': promptAudioUrl,
      'answerAudioUrl': answerAudioUrl,
      'translatedPrompt': translatedPrompt,
      'translatedAnswer': translatedAnswer,
      'translator': translator,
      'isComplete': isComplete
    };
  }
}

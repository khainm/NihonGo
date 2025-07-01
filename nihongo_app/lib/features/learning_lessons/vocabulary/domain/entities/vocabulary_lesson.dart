class VocabularyLesson {
  final int id;
  final String title;
  final String description;
  final int totalWords;
  final int completedWords;
  final String level;
  final List<VocabularyWord> words;
  final Duration estimatedTime;

  VocabularyLesson({
    required this.id,
    required this.title,
    required this.description,
    required this.totalWords,
    required this.completedWords,
    required this.level,
    required this.words,
    required this.estimatedTime,
  });

  double get progress => totalWords > 0 ? completedWords / totalWords : 0.0;
  bool get isCompleted => completedWords >= totalWords;
}

class VocabularyWord {
  final int id;
  final String word;
  final String reading;
  final String meaning;
  final String example;
  final String exampleTranslation;
  final List<String> tags;
  final bool isLearned;

  VocabularyWord({
    required this.id,
    required this.word,
    required this.reading,
    required this.meaning,
    required this.example,
    required this.exampleTranslation,
    required this.tags,
    this.isLearned = false,
  });
}

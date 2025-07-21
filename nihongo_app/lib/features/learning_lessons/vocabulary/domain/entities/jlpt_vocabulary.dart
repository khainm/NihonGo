class JlptLevel {
  final String id; // "N5", "N4", etc.
  final String title;
  final String description;
  final int totalLessons;
  final int completedLessons;
  final bool isUnlocked;

  JlptLevel({
    required this.id,
    required this.title,
    required this.description,
    required this.totalLessons,
    required this.completedLessons,
    required this.isUnlocked,
  });

  double get progressPercentage {
    if (totalLessons == 0) return 0.0;
    return completedLessons / totalLessons;
  }

  bool get isCompleted => completedLessons == totalLessons && totalLessons > 0;
}

class JlptVocabularyLesson {
  final String lessonId; // "n5_bai_1", "n4_bai_1", etc.
  final String jlptLevel; // "N5", "N4", etc.
  final String title;
  final List<JlptVocabularyWord> vocabulary;

  JlptVocabularyLesson({
    required this.lessonId,
    required this.jlptLevel,
    required this.title,
    required this.vocabulary,
  });

  int get totalWords => vocabulary.length;
  int get completedWords => vocabulary.where((word) => word.isLearned).length;
  bool get isCompleted => completedWords == totalWords && totalWords > 0;
  
  double get progressPercentage {
    if (totalWords == 0) return 0.0;
    return completedWords / totalWords;
  }
}

class JlptVocabularyWord {
  final String id;
  final String japanese;
  final String vietnamese;
  final String? reading;
  final String? notes;
  final bool isLearned;

  JlptVocabularyWord({
    required this.id,
    required this.japanese,
    required this.vietnamese,
    this.reading,
    this.notes,
    this.isLearned = false,
  });

  JlptVocabularyWord copyWith({
    String? id,
    String? japanese,
    String? vietnamese,
    String? reading,
    String? notes,
    bool? isLearned,
  }) {
    return JlptVocabularyWord(
      id: id ?? this.id,
      japanese: japanese ?? this.japanese,
      vietnamese: vietnamese ?? this.vietnamese,
      reading: reading ?? this.reading,
      notes: notes ?? this.notes,
      isLearned: isLearned ?? this.isLearned,
    );
  }
}

import '../../domain/entities/vocabulary_lesson.dart';

class VocabularyLessonModel extends VocabularyLesson {
  VocabularyLessonModel({
    required super.id,
    required super.title,
    required super.description,
    required super.totalWords,
    required super.completedWords,
    required super.level,
    required super.words,
    required super.estimatedTime,
  });

  factory VocabularyLessonModel.fromJson(Map<String, dynamic> json) {
    return VocabularyLessonModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      totalWords: json['totalItems'] ?? 0,
      completedWords: json['progress']?['completedItems'] ?? 0,
      level: 'N${json['jlptLevel']}',
      estimatedTime: Duration(minutes: json['estimatedTimeMinutes'] ?? 30),
      words: [], // Will be loaded separately in detail view
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'totalWords': totalWords,
      'completedWords': completedWords,
      'level': level,
      'estimatedMinutes': estimatedTime.inMinutes,
      'words': words.map((w) => (w as VocabularyWordModel).toJson()).toList(),
    };
  }
}

class VocabularyWordModel extends VocabularyWord {
  VocabularyWordModel({
    required super.id,
    required super.word,
    required super.reading,
    required super.meaning,
    required super.example,
    required super.exampleTranslation,
    required super.tags,
    super.isLearned = false,
  });

  factory VocabularyWordModel.fromJson(Map<String, dynamic> json) {
    return VocabularyWordModel(
      id: json['id'],
      word: json['word'],
      reading: json['reading'] ?? '',
      meaning: json['meaning'],
      example: json['examples']?.isNotEmpty == true ? json['examples'][0]['japanese'] ?? '' : '',
      exampleTranslation: json['examples']?.isNotEmpty == true ? json['examples'][0]['translation'] ?? '' : '',
      tags: List<String>.from(json['tags'] ?? []),
      isLearned: json['isLearned'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'word': word,
      'reading': reading,
      'meaning': meaning,
      'example': example,
      'exampleTranslation': exampleTranslation,
      'tags': tags,
      'isLearned': isLearned,
    };
  }
}

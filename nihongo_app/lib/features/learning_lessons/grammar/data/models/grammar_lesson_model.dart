import '../../domain/entities/grammar_lesson.dart';

class GrammarLessonModel extends GrammarLesson {
  GrammarLessonModel({
    required super.id,
    required super.title,
    required super.description,
    required super.level,
    required super.totalGrammarPoints,
    required super.completedGrammarPoints,
    required super.grammarPoints,
    required super.estimatedTime,
    required super.category,
  });

  factory GrammarLessonModel.fromJson(Map<String, dynamic> json) {
    return GrammarLessonModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      totalGrammarPoints: json['totalItems'] ?? 0,
      completedGrammarPoints: json['progress']?['completedItems'] ?? 0,
      level: 'N${json['jlptLevel']}',
      estimatedTime: Duration(minutes: json['estimatedTimeMinutes'] ?? 45),
      category: json['category'] ?? '',
      grammarPoints: [], // Will be loaded separately in detail view
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'totalGrammarPoints': totalGrammarPoints,
      'completedGrammarPoints': completedGrammarPoints,
      'level': level,
      'estimatedMinutes': estimatedTime.inMinutes,
      'category': category,
      'grammarPoints': grammarPoints.map((g) => (g as GrammarPointModel).toJson()).toList(),
    };
  }
}

class GrammarPointModel extends GrammarPoint {
  GrammarPointModel({
    required super.id,
    required super.pattern,
    required super.meaning,
    required super.explanation,
    required super.usage,
    required super.examples,
    required super.relatedPatterns,
    required super.formationRule,
    required super.notes,
    super.isLearned = false,
  });

  factory GrammarPointModel.fromJson(Map<String, dynamic> json) {
    return GrammarPointModel(
      id: json['id'],
      pattern: json['title'] ?? json['pattern'] ?? '',
      meaning: json['meaning'] ?? '',
      explanation: json['usage'] ?? '',
      usage: json['usage'] ?? '',
      examples: (json['examples'] as List?)
          ?.map((e) => GrammarExampleModel.fromJson(e))
          .toList() ?? [],
      relatedPatterns: List<String>.from(json['relatedGrammar'] ?? []),
      formationRule: json['structure'] ?? '',
      notes: List<String>.from(json['tags'] ?? []),
      isLearned: json['isLearned'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pattern': pattern,
      'meaning': meaning,
      'explanation': explanation,
      'usage': usage,
      'examples': examples.map((e) => (e as GrammarExampleModel).toJson()).toList(),
      'relatedPatterns': relatedPatterns,
      'formationRule': formationRule,
      'notes': notes,
      'isLearned': isLearned,
    };
  }
}

class GrammarExampleModel extends GrammarExample {
  GrammarExampleModel({
    required super.id,
    required super.japanese,
    required super.romaji,
    required super.translation,
    required super.highlightedPart,
    required super.context,
  });

  factory GrammarExampleModel.fromJson(Map<String, dynamic> json) {
    return GrammarExampleModel(
      id: json['id'] ?? 0,
      japanese: json['japanese'] ?? '',
      romaji: json['romaji'] ?? '',
      translation: json['translation'] ?? '',
      highlightedPart: json['highlightedPart'] ?? '',
      context: json['context'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'japanese': japanese,
      'romaji': romaji,
      'translation': translation,
      'highlightedPart': highlightedPart,
      'context': context,
    };
  }
}

class GrammarLessonDetailModel {
  final GrammarLessonModel lesson;
  final List<GrammarPointModel> grammarPoints;

  GrammarLessonDetailModel({
    required this.lesson,
    required this.grammarPoints,
  });

  factory GrammarLessonDetailModel.fromJson(Map<String, dynamic> json) {
    return GrammarLessonDetailModel(
      lesson: GrammarLessonModel.fromJson(json['lesson']),
      grammarPoints: (json['grammarPoints'] as List)
          .map((g) => GrammarPointModel.fromJson(g))
          .toList(),
    );
  }
}

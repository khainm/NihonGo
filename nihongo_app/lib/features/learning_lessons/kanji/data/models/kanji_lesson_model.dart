import '../../domain/entities/kanji_lesson.dart';

class KanjiLessonModel extends KanjiLesson {
  KanjiLessonModel({
    required super.id,
    required super.title,
    required super.description,
    required super.totalKanji,
    required super.completedKanji,
    required super.level,
  });

  factory KanjiLessonModel.fromJson(Map<String, dynamic> json) {
    return KanjiLessonModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      totalKanji: json['totalItems'] ?? 0,
      completedKanji: json['progress']?['completedItems'] ?? 0,
      level: 'N${json['jlptLevel']}',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'totalKanji': totalKanji,
      'completedKanji': completedKanji,
      'level': level,
    };
  }
}

class KanjiLessonDetailModel {
  final KanjiLessonModel lesson;
  final List<KanjiItemModel> kanjiList;

  KanjiLessonDetailModel({
    required this.lesson,
    required this.kanjiList,
  });

  factory KanjiLessonDetailModel.fromJson(Map<String, dynamic> json) {
    return KanjiLessonDetailModel(
      lesson: KanjiLessonModel.fromJson(json['lesson']),
      kanjiList: (json['kanjiList'] as List)
          .map((k) => KanjiItemModel.fromJson(k))
          .toList(),
    );
  }
}

class KanjiItemModel {
  final String id;
  final String character;
  final String meaning;
  final List<String> onyomi;
  final List<String> kunyomi;
  final int strokeCount;
  final List<String> examples;
  final bool isLearned;

  KanjiItemModel({
    required this.id,
    required this.character,
    required this.meaning,
    required this.onyomi,
    required this.kunyomi,
    required this.strokeCount,
    required this.examples,
    this.isLearned = false,
  });

  factory KanjiItemModel.fromJson(Map<String, dynamic> json) {
    return KanjiItemModel(
      id: json['id'],
      character: json['character'],
      meaning: json['meaning'],
      onyomi: List<String>.from(json['onyomi'] ?? []),
      kunyomi: List<String>.from(json['kunyomi'] ?? []),
      strokeCount: json['strokeCount'] ?? 0,
      examples: (json['compounds'] as List?)?.map((c) => c['word'].toString()).toList() ?? [],
      isLearned: json['isLearned'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'character': character,
      'meaning': meaning,
      'onyomi': onyomi,
      'kunyomi': kunyomi,
      'strokeCount': strokeCount,
      'examples': examples,
      'isLearned': isLearned,
    };
  }
}

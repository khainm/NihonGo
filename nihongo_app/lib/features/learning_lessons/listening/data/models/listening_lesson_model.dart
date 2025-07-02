import '../../domain/entities/listening_lesson.dart';

class ListeningLessonModel extends ListeningLesson {
  ListeningLessonModel({
    required super.id,
    required super.title,
    required super.description,
    required super.totalExercises,
    required super.completedExercises,
    required super.level,
    required super.duration,
  });

  factory ListeningLessonModel.fromJson(Map<String, dynamic> json) {
    return ListeningLessonModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      totalExercises: json['totalItems'] ?? 0,
      completedExercises: json['progress']?['completedItems'] ?? 0,
      level: 'N${json['jlptLevel']}',
      duration: Duration(minutes: json['estimatedTimeMinutes'] ?? 60),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'totalExercises': totalExercises,
      'completedExercises': completedExercises,
      'level': level,
      'duration': duration.inMinutes,
    };
  }
}

class ListeningLessonDetailModel {
  final ListeningLessonModel lesson;
  final List<ListeningExerciseModel> exercises;

  ListeningLessonDetailModel({
    required this.lesson,
    required this.exercises,
  });

  factory ListeningLessonDetailModel.fromJson(Map<String, dynamic> json) {
    return ListeningLessonDetailModel(
      lesson: ListeningLessonModel.fromJson(json['lesson']),
      exercises: (json['exercises'] as List)
          .map((e) => ListeningExerciseModel.fromJson(e))
          .toList(),
    );
  }
}

class ListeningExerciseModel {
  final String id;
  final String title;
  final String description;
  final String audioUrl;
  final String transcript;
  final String translation;
  final int duration;
  final String difficulty;
  final List<ListeningQuestionModel> questions;
  final bool isCompleted;

  ListeningExerciseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.audioUrl,
    required this.transcript,
    required this.translation,
    required this.duration,
    required this.difficulty,
    required this.questions,
    this.isCompleted = false,
  });

  factory ListeningExerciseModel.fromJson(Map<String, dynamic> json) {
    return ListeningExerciseModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      audioUrl: json['audioUrl'] ?? '',
      transcript: json['transcript'] ?? '',
      translation: json['translation'] ?? '',
      duration: json['duration'] ?? 0,
      difficulty: json['difficulty'] ?? 'BEGINNER',
      questions: (json['questions'] as List?)
          ?.map((q) => ListeningQuestionModel.fromJson(q))
          .toList() ?? [],
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'audioUrl': audioUrl,
      'transcript': transcript,
      'translation': translation,
      'duration': duration,
      'difficulty': difficulty,
      'questions': questions.map((q) => q.toJson()).toList(),
      'isCompleted': isCompleted,
    };
  }
}

class ListeningQuestionModel {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String explanation;

  ListeningQuestionModel({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });

  factory ListeningQuestionModel.fromJson(Map<String, dynamic> json) {
    return ListeningQuestionModel(
      id: json['id'],
      question: json['question'],
      options: List<String>.from(json['options'] ?? []),
      correctAnswer: json['correctAnswer'] ?? 0,
      explanation: json['explanation'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
    };
  }
}

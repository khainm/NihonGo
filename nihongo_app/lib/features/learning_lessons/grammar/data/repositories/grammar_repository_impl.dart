import '../../domain/entities/grammar_lesson.dart';
import '../datasources/grammar_lesson_remote_datasource.dart';

class GrammarRepositoryImpl {
  final GrammarLessonRemoteDataSource remoteDataSource;
  
  GrammarRepositoryImpl({
    required this.remoteDataSource,
  });

  Future<List<GrammarLesson>> getGrammarLessons(String level, {String? userId}) async {
    try {
      final lessonModels = await remoteDataSource.getGrammarLessons(level, userId: userId);
      return lessonModels;
    } catch (e) {
      throw Exception('Failed to get grammar lessons: $e');
    }
  }

  Future<GrammarLesson> getGrammarLessonById(int id, {String? userId}) async {
    try {
      final lessonDetail = await remoteDataSource.getGrammarLessonDetail(id.toString(), userId: userId);
      return lessonDetail.lesson.copyWith(grammarPoints: lessonDetail.grammarPoints);
    } catch (e) {
      throw Exception('Failed to get grammar lesson detail: $e');
    }
  }

  Future<void> updateProgressWithContext(String userId, String lessonId, String itemId, bool isLearned) async {
    try {
      await remoteDataSource.updateProgress(userId, lessonId, itemId, isLearned);
    } catch (e) {
      throw Exception('Failed to update progress: $e');
    }
  }
}

// Extension to add copyWith method
extension GrammarLessonModelExtension on GrammarLesson {
  GrammarLesson copyWith({
    int? id,
    String? title,
    String? description,
    String? level,
    int? totalGrammarPoints,
    int? completedGrammarPoints,
    List<GrammarPoint>? grammarPoints,
    Duration? estimatedTime,
    String? category,
  }) {
    return GrammarLesson(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      level: level ?? this.level,
      totalGrammarPoints: totalGrammarPoints ?? this.totalGrammarPoints,
      completedGrammarPoints: completedGrammarPoints ?? this.completedGrammarPoints,
      grammarPoints: grammarPoints ?? this.grammarPoints,
      estimatedTime: estimatedTime ?? this.estimatedTime,
      category: category ?? this.category,
    );
  }
}

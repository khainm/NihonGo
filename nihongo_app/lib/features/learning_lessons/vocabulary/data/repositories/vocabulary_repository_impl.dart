import '../../domain/entities/vocabulary_lesson.dart';
import '../../domain/repositories/vocabulary_repository.dart';
import '../datasources/vocabulary_lesson_remote_datasource.dart';

class VocabularyRepositoryImpl implements VocabularyRepository {
  final VocabularyLessonRemoteDataSource remoteDataSource;
  
  VocabularyRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<List<VocabularyLesson>> getVocabularyLessons(String level) async {
    try {
      final lessonModels = await remoteDataSource.getVocabularyLessons(level);
      return lessonModels;
    } catch (e) {
      throw Exception('Failed to get vocabulary lessons: $e');
    }
  }

  @override
  Future<VocabularyLesson> getVocabularyLessonById(int id) async {
    try {
      final lessonDetail = await remoteDataSource.getVocabularyLessonDetail(id.toString());
      // Convert the detail model to match the expected VocabularyLesson structure
      return lessonDetail.lesson.copyWith(words: lessonDetail.words);
    } catch (e) {
      throw Exception('Failed to get vocabulary lesson detail: $e');
    }
  }

  @override
  Future<List<VocabularyWord>> getVocabularyWords(int lessonId) async {
    try {
      final lessonDetail = await remoteDataSource.getVocabularyLessonDetail(lessonId.toString());
      return lessonDetail.words;
    } catch (e) {
      throw Exception('Failed to get vocabulary words: $e');
    }
  }

  @override
  Future<void> markWordAsLearned(int wordId) async {
    try {
      // This would need userId, lessonId from context
      // For now, we'll throw an exception indicating this needs to be implemented
      // with proper user context
      throw UnimplementedError('markWordAsLearned needs user context - use updateLessonProgress instead');
    } catch (e) {
      throw Exception('Failed to mark word as learned: $e');
    }
  }

  @override
  Future<void> updateLessonProgress(int lessonId, int completedWords) async {
    try {
      // This would need userId from context
      // For now, we'll throw an exception indicating this needs to be implemented
      // with proper user context
      throw UnimplementedError('updateLessonProgress needs user context');
    } catch (e) {
      throw Exception('Failed to update lesson progress: $e');
    }
  }

  // New method to update progress with proper context
  Future<void> updateProgressWithContext(String userId, String lessonId, String itemId, bool isLearned) async {
    try {
      await remoteDataSource.updateProgress(userId, lessonId, itemId, isLearned);
    } catch (e) {
      throw Exception('Failed to update progress: $e');
    }
  }
}

// Extension to add copyWith method to VocabularyLessonModel
extension VocabularyLessonModelExtension on VocabularyLesson {
  VocabularyLesson copyWith({
    int? id,
    String? title,
    String? description,
    int? totalWords,
    int? completedWords,
    String? level,
    List<VocabularyWord>? words,
    Duration? estimatedTime,
  }) {
    return VocabularyLesson(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      totalWords: totalWords ?? this.totalWords,
      completedWords: completedWords ?? this.completedWords,
      level: level ?? this.level,
      words: words ?? this.words,
      estimatedTime: estimatedTime ?? this.estimatedTime,
    );
  }
}

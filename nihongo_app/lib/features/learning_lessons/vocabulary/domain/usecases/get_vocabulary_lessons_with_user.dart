import '../entities/vocabulary_lesson.dart';
import '../../data/repositories/vocabulary_repository_impl.dart';

class GetVocabularyLessonsWithUser {
  final VocabularyRepositoryImpl repository;

  GetVocabularyLessonsWithUser(this.repository);

  Future<List<VocabularyLesson>> call(String level, {String? userId}) async {
    return await repository.getVocabularyLessons(level);
  }
}

class GetVocabularyLessonDetailWithUser {
  final VocabularyRepositoryImpl repository;

  GetVocabularyLessonDetailWithUser(this.repository);

  Future<VocabularyLesson> call(int lessonId, {String? userId}) async {
    return await repository.getVocabularyLessonById(lessonId);
  }
}

class UpdateVocabularyProgress {
  final VocabularyRepositoryImpl repository;

  UpdateVocabularyProgress(this.repository);

  Future<void> call({
    required String userId,
    required String lessonId,
    required String itemId,
    required bool isLearned,
  }) async {
    return await repository.updateProgressWithContext(userId, lessonId, itemId, isLearned);
  }
}

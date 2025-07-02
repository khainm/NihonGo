import '../entities/grammar_lesson.dart';
import '../../data/repositories/grammar_repository_impl.dart';

class GetGrammarLessonsWithUser {
  final GrammarRepositoryImpl repository;

  GetGrammarLessonsWithUser(this.repository);

  Future<List<GrammarLesson>> call(String level, {String? userId}) async {
    return await repository.getGrammarLessons(level, userId: userId);
  }
}

class GetGrammarLessonDetailWithUser {
  final GrammarRepositoryImpl repository;

  GetGrammarLessonDetailWithUser(this.repository);

  Future<GrammarLesson> call(int lessonId, {String? userId}) async {
    return await repository.getGrammarLessonById(lessonId, userId: userId);
  }
}

class UpdateGrammarProgress {
  final GrammarRepositoryImpl repository;

  UpdateGrammarProgress(this.repository);

  Future<void> call({
    required String userId,
    required String lessonId,
    required String itemId,
    required bool isLearned,
  }) async {
    return await repository.updateProgressWithContext(userId, lessonId, itemId, isLearned);
  }
}

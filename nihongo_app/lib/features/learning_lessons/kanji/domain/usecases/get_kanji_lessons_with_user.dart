import '../entities/kanji_lesson.dart';
import '../../data/repositories/kanji_repository_impl.dart';
import '../../data/models/kanji_lesson_model.dart';

class GetKanjiLessonsWithUser {
  final KanjiRepositoryImpl repository;

  GetKanjiLessonsWithUser(this.repository);

  Future<List<KanjiLesson>> call(String level, {String? userId}) async {
    return await repository.getKanjiLessons(level, userId: userId);
  }
}

class GetKanjiLessonDetailWithUser {
  final KanjiRepositoryImpl repository;

  GetKanjiLessonDetailWithUser(this.repository);

  Future<KanjiLessonDetailModel> call(int lessonId, {String? userId}) async {
    return await repository.getKanjiLessonById(lessonId, userId: userId);
  }
}

class UpdateKanjiProgress {
  final KanjiRepositoryImpl repository;

  UpdateKanjiProgress(this.repository);

  Future<void> call({
    required String userId,
    required String lessonId,
    required String itemId,
    required bool isLearned,
  }) async {
    return await repository.updateProgressWithContext(userId, lessonId, itemId, isLearned);
  }
}

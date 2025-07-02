import '../entities/listening_lesson.dart';
import '../../data/repositories/listening_repository_impl.dart';
import '../../data/models/listening_lesson_model.dart';

class GetListeningLessonsWithUser {
  final ListeningRepositoryImpl repository;

  GetListeningLessonsWithUser(this.repository);

  Future<List<ListeningLesson>> call(String level, {String? userId}) async {
    return await repository.getListeningLessons(level, userId: userId);
  }
}

class GetListeningLessonDetailWithUser {
  final ListeningRepositoryImpl repository;

  GetListeningLessonDetailWithUser(this.repository);

  Future<ListeningLessonDetailModel> call(int lessonId, {String? userId}) async {
    return await repository.getListeningLessonById(lessonId, userId: userId);
  }
}

class UpdateListeningProgress {
  final ListeningRepositoryImpl repository;

  UpdateListeningProgress(this.repository);

  Future<void> call({
    required String userId,
    required String lessonId,
    required String itemId,
    required bool isLearned,
  }) async {
    return await repository.updateProgressWithContext(userId, lessonId, itemId, isLearned);
  }
}

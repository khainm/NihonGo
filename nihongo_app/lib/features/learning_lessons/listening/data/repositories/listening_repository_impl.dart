import '../../domain/entities/listening_lesson.dart';
import '../datasources/listening_lesson_remote_datasource.dart';
import '../models/listening_lesson_model.dart';

class ListeningRepositoryImpl {
  final ListeningLessonRemoteDataSource remoteDataSource;
  
  ListeningRepositoryImpl({
    required this.remoteDataSource,
  });

  Future<List<ListeningLesson>> getListeningLessons(String level, {String? userId}) async {
    try {
      final lessonModels = await remoteDataSource.getListeningLessons(level, userId: userId);
      return lessonModels;
    } catch (e) {
      throw Exception('Failed to get listening lessons: $e');
    }
  }

  Future<ListeningLessonDetailModel> getListeningLessonById(int id, {String? userId}) async {
    try {
      final lessonDetail = await remoteDataSource.getListeningLessonDetail(id.toString(), userId: userId);
      return lessonDetail;
    } catch (e) {
      throw Exception('Failed to get listening lesson detail: $e');
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

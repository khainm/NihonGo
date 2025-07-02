import '../../domain/entities/kanji_lesson.dart';
import '../datasources/kanji_lesson_remote_datasource.dart';
import '../models/kanji_lesson_model.dart';

class KanjiRepositoryImpl {
  final KanjiLessonRemoteDataSource remoteDataSource;
  
  KanjiRepositoryImpl({
    required this.remoteDataSource,
  });

  Future<List<KanjiLesson>> getKanjiLessons(String level, {String? userId}) async {
    try {
      final lessonModels = await remoteDataSource.getKanjiLessons(level, userId: userId);
      return lessonModels;
    } catch (e) {
      throw Exception('Failed to get kanji lessons: $e');
    }
  }

  Future<KanjiLessonDetailModel> getKanjiLessonById(int id, {String? userId}) async {
    try {
      final lessonDetail = await remoteDataSource.getKanjiLessonDetail(id.toString(), userId: userId);
      return lessonDetail;
    } catch (e) {
      throw Exception('Failed to get kanji lesson detail: $e');
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

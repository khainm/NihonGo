import '../entities/grammar_lesson.dart';

abstract class GrammarRepository {
  Future<List<GrammarLesson>> getGrammarLessons(String level);
  Future<GrammarLesson> getGrammarLessonById(int id);
  Future<List<GrammarPoint>> getGrammarPoints(int lessonId);
  Future<void> markGrammarPointAsLearned(int grammarPointId);
  Future<void> updateLessonProgress(int lessonId, int completedPoints);
  Future<List<GrammarLesson>> getGrammarLessonsByCategory(String category);
}

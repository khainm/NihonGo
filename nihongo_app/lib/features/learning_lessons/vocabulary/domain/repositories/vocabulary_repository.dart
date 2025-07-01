import '../entities/vocabulary_lesson.dart';

abstract class VocabularyRepository {
  Future<List<VocabularyLesson>> getVocabularyLessons(String level);
  Future<VocabularyLesson> getVocabularyLessonById(int id);
  Future<List<VocabularyWord>> getVocabularyWords(int lessonId);
  Future<void> markWordAsLearned(int wordId);
  Future<void> updateLessonProgress(int lessonId, int completedWords);
}

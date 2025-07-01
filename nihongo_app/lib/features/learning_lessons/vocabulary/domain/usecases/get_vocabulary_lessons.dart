import '../entities/vocabulary_lesson.dart';
import '../repositories/vocabulary_repository.dart';

class GetVocabularyLessons {
  final VocabularyRepository repository;

  GetVocabularyLessons(this.repository);

  Future<List<VocabularyLesson>> call(String level) async {
    return await repository.getVocabularyLessons(level);
  }
}

class GetVocabularyLessonDetail {
  final VocabularyRepository repository;

  GetVocabularyLessonDetail(this.repository);

  Future<VocabularyLesson> call(int lessonId) async {
    return await repository.getVocabularyLessonById(lessonId);
  }
}

class MarkWordAsLearned {
  final VocabularyRepository repository;

  MarkWordAsLearned(this.repository);

  Future<void> call(int wordId) async {
    return await repository.markWordAsLearned(wordId);
  }
}

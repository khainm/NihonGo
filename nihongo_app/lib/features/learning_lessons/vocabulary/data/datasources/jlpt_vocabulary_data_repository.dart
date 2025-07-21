import '../../domain/entities/jlpt_vocabulary.dart';
import '../services/jlpt_vocabulary_api_service.dart';

class JlptVocabularyDataRepository {
  // TODO: Implement SharedPreferences for progress tracking
  // static const String _progressKey = 'jlpt_vocabulary_progress';
  
  final JlptVocabularyApiService _apiService = JlptVocabularyApiService();

  // Lấy danh sách tất cả levels từ MongoDB thông qua API
  Future<List<JlptLevel>> getAllLevels() async {
    try {
      // Lấy danh sách bài học từ tất cả các level để tính toán thống kê
      final levels = ['N5', 'N4', 'N3', 'N2', 'N1'];
      List<JlptLevel> result = [];
      
      for (String level in levels) {
        final lessons = await _apiService.getAllLessons(jlptLevel: level);
        final totalLessons = lessons.length;
        final completedLessons = lessons.where((lesson) => lesson.isCompleted).length;
        
        result.add(JlptLevel(
          id: level,
          title: 'JLPT $level',
          description: _getLevelDescription(level),
          totalLessons: totalLessons,
          completedLessons: completedLessons,
          isUnlocked: level == 'N5' || completedLessons > 0,
        ));
      }
      
      return result;
    } catch (e) {
      print('Error loading levels from API: $e');
      // Trả về danh sách rỗng nếu không kết nối được với MongoDB
      return [];
    }
  }

  String _getLevelDescription(String level) {
    switch (level) {
      case 'N5': return 'Trình độ cơ bản';
      case 'N4': return 'Trình độ trung cấp thấp';
      case 'N3': return 'Trình độ trung cấp';
      case 'N2': return 'Trình độ trung cấp cao';
      case 'N1': return 'Trình độ cao cấp';
      default: return 'Trình độ JLPT';
    }
  }

  // Lấy danh sách bài học theo level từ API
  Future<List<JlptVocabularyLesson>> getLessonsByLevel(String jlptLevel) async {
    try {
      return await _apiService.getAllLessons(jlptLevel: jlptLevel);
    } catch (e) {
      print('Error loading lessons from API: $e');
      return []; // Trả về list rỗng nếu có lỗi
    }
  }

  // Lấy một bài học cụ thể từ API
  Future<JlptVocabularyLesson?> getLesson(String jlptLevel, String lessonKey) async {
    try {
      // Extract lesson number from lessonKey (e.g., "bai_1" -> 1)
      final lessonNumber = int.tryParse(lessonKey.split('_').last);
      if (lessonNumber == null) return null;
      
      return await _apiService.getLessonWithProgress(
        jlptLevel: jlptLevel,
        lessonNumber: lessonNumber,
      );
    } catch (e) {
      print('Error loading lesson from API: $e');
      return null;
    }
  }

  // Lấy từ vựng theo level và lesson number từ API
  Future<List<JlptVocabularyWord>> getVocabularyByLevelAndLesson(String jlptLevel, int lessonNumber) async {
    try {
      final lesson = await _apiService.getLessonWithProgress(
        jlptLevel: jlptLevel,
        lessonNumber: lessonNumber,
      );
      return lesson?.vocabulary ?? [];
    } catch (e) {
      print('Error loading vocabulary from API: $e');
      return [];
    }
  }

  // Build level từ dữ liệu - KHÔNG SỬ DỤNG NỮA
  // JlptLevel _buildLevelFromData(String levelId, Map<String, dynamic> levelData) {
  //   final lessonsDataRaw = levelData['lessons'];
  //   final lessonsData = Map<String, dynamic>.from(lessonsDataRaw as Map);
  //   final totalLessons = lessonsData.length;
  //   final completedLessons = 0; // TODO: Calculate from progress
    
  //   return JlptLevel(
  //     id: levelId,
  //     title: levelData['title'],
  //     description: levelData['description'],
  //     totalLessons: totalLessons,
  //     completedLessons: completedLessons,
  //     isUnlocked: levelId == 'N5' || completedLessons > 0,
  //   );
  // }

  // Build lesson từ dữ liệu JSON - KHÔNG SỬ DỤNG NỮA
  // JlptVocabularyLesson _buildLessonFromData(String lessonId, String jlptLevel, Map<String, dynamic> lessonData) {
  //   Map<String, bool> learnedWords = {};
    
  //   final tuVungList = lessonData['tu_vung'] as List;
  //   final words = tuVungList.asMap().entries.map((entry) {
  //     final index = entry.key;
  //     final wordData = entry.value as Map<String, dynamic>;
  //     final wordId = '${lessonId}_$index';
      
  //     return JlptVocabularyWord(
  //       id: wordId,
  //       japanese: wordData['japanese'],
  //       vietnamese: wordData['vietnamese'],
  //       reading: wordData['reading'],
  //       notes: wordData['notes'],
  //       isLearned: learnedWords[wordId] ?? false,
  //     );
  //   }).toList();

  //   return JlptVocabularyLesson(
  //     lessonId: lessonId,
  //     jlptLevel: jlptLevel,
  //     title: lessonData['title'] ?? 'Bài học',
  //     vocabulary: words,
  //   );
  // }

  // Helper methods for specific levels - SỬ DỤNG API
  Future<List<JlptVocabularyLesson>> getN5Lessons() => getLessonsByLevel('N5');
  Future<List<JlptVocabularyLesson>> getN4Lessons() => getLessonsByLevel('N4');
  Future<List<JlptVocabularyLesson>> getN3Lessons() => getLessonsByLevel('N3');
  Future<List<JlptVocabularyLesson>> getN2Lessons() => getLessonsByLevel('N2');
  Future<List<JlptVocabularyLesson>> getN1Lessons() => getLessonsByLevel('N1');

  // Kiểm tra level có tồn tại không
  bool hasLevel(String jlptLevel) {
    return ['N5', 'N4', 'N3', 'N2', 'N1'].contains(jlptLevel);
  }

  // Lấy danh sách ID của tất cả levels
  List<String> getAllLevelIds() {
    return ['N5', 'N4', 'N3', 'N2', 'N1'];
  }
}

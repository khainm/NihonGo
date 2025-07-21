import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/jlpt_vocabulary.dart';

class JlptVocabularyApiService {
  static const String baseUrl = 'http://10.0.2.2:8081';
  static const String jlptPath = '/api/learning/jlpt-vocabulary';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<JlptVocabularyLesson?> getLessonWithProgress({
    required String jlptLevel,
    required int lessonNumber,
  }) async {
    try {
      final token = await _getToken();
      print('DEBUG: Getting lesson with token: $token');

      final response = await http.get(
        Uri.parse('$baseUrl$jlptPath/levels/$jlptLevel/lessons/$lessonNumber'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      print('DEBUG: Lesson API response: ${response.statusCode}');
      print('DEBUG: Lesson API body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return _parseLesson(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('Exception getting lesson: $e');
      return null;
    }
  }

  Future<List<JlptVocabularyLesson>> getAllLessons({
    required String jlptLevel,
  }) async {
    try {
      final token = await _getToken();
      
      final response = await http.get(
        Uri.parse('$baseUrl$jlptPath/levels/$jlptLevel/lessons'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      print('DEBUG: All lessons API response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> lessonsData = data['data'];
          return lessonsData.map((lessonJson) => _parseLesson(lessonJson)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Exception getting all lessons: $e');
      return [];
    }
  }

  JlptVocabularyLesson _parseLesson(Map<String, dynamic> json) {
    final vocabularyList = json['vocabulary'] as List<dynamic>? ?? [];
    
    return JlptVocabularyLesson(
      lessonId: json['lesson_id'] ?? json['lessonId'] ?? '',
      jlptLevel: json['jlpt_level'] ?? json['jlptLevel'] ?? '',
      title: json['title'] ?? '',
      vocabulary: vocabularyList.map((vocabJson) => JlptVocabularyWord(
        id: vocabJson['id'] ?? '',
        japanese: vocabJson['japanese'] ?? '',
        vietnamese: vocabJson['vietnamese'] ?? '',
        reading: vocabJson['reading'],
        notes: vocabJson['notes'],
        isLearned: vocabJson['is_learned'] ?? vocabJson['isLearned'] ?? false,
      )).toList(),
    );
  }

  Future<Map<String, dynamic>?> getUserStats({
    required String jlptLevel,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) return null;

      final response = await http.get(
        Uri.parse('$baseUrl$jlptPath/levels/$jlptLevel/stats'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      }
      return null;
    } catch (e) {
      print('Exception getting user stats: $e');
      return null;
    }
  }
}

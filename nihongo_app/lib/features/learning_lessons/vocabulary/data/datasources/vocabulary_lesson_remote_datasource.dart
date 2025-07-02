import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/vocabulary_lesson_model.dart';

abstract class VocabularyLessonRemoteDataSource {
  Future<List<VocabularyLessonModel>> getVocabularyLessons(String level, {String? userId});
  Future<VocabularyLessonDetailModel> getVocabularyLessonDetail(String lessonId, {String? userId});
  Future<void> updateProgress(String userId, String lessonId, String itemId, bool isLearned);
}

class VocabularyLessonRemoteDataSourceImpl implements VocabularyLessonRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  VocabularyLessonRemoteDataSourceImpl({
    required this.client,
    this.baseUrl = 'http://localhost:8080/api/learning',
  });

  @override
  Future<List<VocabularyLessonModel>> getVocabularyLessons(String level, {String? userId}) async {
    final uri = Uri.parse('$baseUrl/lessons/type/VOCABULARY')
        .replace(queryParameters: {
      'jlptLevel': level,
      if (userId != null) 'userId': userId,
    });

    final response = await client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final data = jsonResponse['data'];
      final items = data['items'] as List;
      
      return items.map((json) => VocabularyLessonModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load vocabulary lessons: ${response.statusCode}');
    }
  }

  @override
  Future<VocabularyLessonDetailModel> getVocabularyLessonDetail(String lessonId, {String? userId}) async {
    final uri = Uri.parse('$baseUrl/lessons/$lessonId')
        .replace(queryParameters: {
      if (userId != null) 'userId': userId,
    });

    final response = await client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final data = jsonResponse['data'];
      
      return VocabularyLessonDetailModel.fromJson(data);
    } else {
      throw Exception('Failed to load vocabulary lesson detail: ${response.statusCode}');
    }
  }

  @override
  Future<void> updateProgress(String userId, String lessonId, String itemId, bool isLearned) async {
    final uri = Uri.parse('$baseUrl/lessons/progress/$userId');

    final response = await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'lessonId': lessonId,
        'itemId': itemId,
        'isLearned': isLearned,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update progress: ${response.statusCode}');
    }
  }
}

class VocabularyLessonDetailModel {
  final VocabularyLessonModel lesson;
  final List<VocabularyWordModel> words;

  VocabularyLessonDetailModel({
    required this.lesson,
    required this.words,
  });

  factory VocabularyLessonDetailModel.fromJson(Map<String, dynamic> json) {
    return VocabularyLessonDetailModel(
      lesson: VocabularyLessonModel.fromJson(json['lesson']),
      words: (json['words'] as List)
          .map((w) => VocabularyWordModel.fromJson(w))
          .toList(),
    );
  }
}

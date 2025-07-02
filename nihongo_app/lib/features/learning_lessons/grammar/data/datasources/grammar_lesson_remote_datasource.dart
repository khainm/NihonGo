import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/grammar_lesson_model.dart';

abstract class GrammarLessonRemoteDataSource {
  Future<List<GrammarLessonModel>> getGrammarLessons(String level, {String? userId});
  Future<GrammarLessonDetailModel> getGrammarLessonDetail(String lessonId, {String? userId});
  Future<void> updateProgress(String userId, String lessonId, String itemId, bool isLearned);
}

class GrammarLessonRemoteDataSourceImpl implements GrammarLessonRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  GrammarLessonRemoteDataSourceImpl({
    required this.client,
    this.baseUrl = 'http://localhost:8080/api/learning',
  });

  @override
  Future<List<GrammarLessonModel>> getGrammarLessons(String level, {String? userId}) async {
    final uri = Uri.parse('$baseUrl/lessons/type/GRAMMAR')
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
      
      return items.map((json) => GrammarLessonModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load grammar lessons: ${response.statusCode}');
    }
  }

  @override
  Future<GrammarLessonDetailModel> getGrammarLessonDetail(String lessonId, {String? userId}) async {
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
      
      return GrammarLessonDetailModel.fromJson(data);
    } else {
      throw Exception('Failed to load grammar lesson detail: ${response.statusCode}');
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

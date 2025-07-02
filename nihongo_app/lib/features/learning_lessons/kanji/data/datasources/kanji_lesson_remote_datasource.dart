import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/kanji_lesson_model.dart';

abstract class KanjiLessonRemoteDataSource {
  Future<List<KanjiLessonModel>> getKanjiLessons(String level, {String? userId});
  Future<KanjiLessonDetailModel> getKanjiLessonDetail(String lessonId, {String? userId});
  Future<void> updateProgress(String userId, String lessonId, String itemId, bool isLearned);
}

class KanjiLessonRemoteDataSourceImpl implements KanjiLessonRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  KanjiLessonRemoteDataSourceImpl({
    required this.client,
    this.baseUrl = 'http://localhost:8080/api/learning',
  });

  @override
  Future<List<KanjiLessonModel>> getKanjiLessons(String level, {String? userId}) async {
    final uri = Uri.parse('$baseUrl/lessons/type/KANJI')
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
      
      return items.map((json) => KanjiLessonModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load kanji lessons: ${response.statusCode}');
    }
  }

  @override
  Future<KanjiLessonDetailModel> getKanjiLessonDetail(String lessonId, {String? userId}) async {
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
      
      return KanjiLessonDetailModel.fromJson(data);
    } else {
      throw Exception('Failed to load kanji lesson detail: ${response.statusCode}');
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

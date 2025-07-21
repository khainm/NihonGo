import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class JlptProgressService {
  static const String baseUrl = 'http://10.0.2.2:8081';
  static const String progressPath = '/api/learning/jlpt-vocabulary';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  String? _getUserIdFromToken(String token) {
    try {
      // JWT token format: header.payload.signature
      final parts = token.split('.');
      if (parts.length != 3) return null;
      
      // Decode the payload (second part)
      final payload = parts[1];
      // Add padding if needed for base64 decoding
      final normalizedPayload = _base64Normalize(payload);
      final decoded = utf8.decode(base64.decode(normalizedPayload));
      final Map<String, dynamic> data = jsonDecode(decoded);
      
      return data['sub']; // 'sub' field contains the user email/ID
    } catch (e) {
      print('Error decoding token: $e');
      return null;
    }
  }

  String _base64Normalize(String str) {
    switch (str.length % 4) {
      case 0:
        break;
      case 2:
        str += '==';
        break;
      case 3:
        str += '=';
        break;
      default:
        throw 'Illegal base64url string!';
    }
    return str;
  }

  Future<bool> updateWordProgress({
    required String jlptLevel,
    required String lessonId,
    required String wordId,
    required bool isLearned,
  }) async {
    try {
      final token = await _getToken();
      print('DEBUG: Token = $token');
      
      if (token == null) {
        print('DEBUG: User not authenticated - no token found');
        throw Exception('User not authenticated');
      }

      final userId = _getUserIdFromToken(token);
      if (userId == null) {
        print('Could not extract userId from token');
        throw Exception('Invalid token format');
      }

      final requestBody = {
        'user_id': userId,
        'jlpt_level': jlptLevel,
        'lesson_id': lessonId,
        'word_id': wordId,
        'is_learned': isLearned,
      };
      
      print('DEBUG: Sending request to $baseUrl$progressPath/progress');
      print('DEBUG: Request body: $requestBody');

      final response = await http.post(
        Uri.parse('$baseUrl$progressPath/progress'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print('DEBUG: Response status: ${response.statusCode}');
      print('DEBUG: Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      } else {
        print('Error updating progress: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception updating progress: $e');
      return false;
    }
  }

  Future<bool> resetLessonProgress({
    required String jlptLevel,
    required int lessonNumber,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('User not authenticated');
      }

      final response = await http.delete(
        Uri.parse('$baseUrl$progressPath/levels/$jlptLevel/lessons/$lessonNumber/progress'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      } else {
        print('Error resetting lesson progress: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception resetting lesson progress: $e');
      return false;
    }
  }

  Future<bool> resetLevelProgress({
    required String jlptLevel,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('User not authenticated');
      }

      final response = await http.delete(
        Uri.parse('$baseUrl$progressPath/levels/$jlptLevel/progress'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      } else {
        print('Error resetting level progress: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception resetting level progress: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getLessonProgress({
    required String jlptLevel,
    required int lessonNumber,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('User not authenticated');
      }

      final response = await http.get(
        Uri.parse('$baseUrl$progressPath/levels/$jlptLevel/lessons/$lessonNumber'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        print('Error getting lesson progress: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception getting lesson progress: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserStats({
    required String jlptLevel,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('User not authenticated');
      }

      final response = await http.get(
        Uri.parse('$baseUrl$progressPath/levels/$jlptLevel/stats'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        print('Error getting user stats: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception getting user stats: $e');
      return null;
    }
  }
}

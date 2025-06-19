import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkService {
  final http.Client client;
  
  NetworkService({required this.client});
  
  Future<Map<String, dynamic>> post({
    required String url,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await client.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          ...?headers,
        },
        body: jsonEncode(body),
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw NetworkException(
          message: error['message'] ?? 'Request failed',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException(
        message: 'Network error: ${e.toString()}',
        statusCode: 0,
      );
    }
  }
  
  Future<Map<String, dynamic>> get({
    required String url,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await client.get(
        Uri.parse(url),
        headers: headers,
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw NetworkException(
          message: error['message'] ?? 'Request failed',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException(
        message: 'Network error: ${e.toString()}',
        statusCode: 0,
      );
    }
  }
}

class NetworkException implements Exception {
  final String message;
  final int statusCode;
  
  NetworkException({
    required this.message,
    required this.statusCode,
  });
  
  @override
  String toString() => message;
}

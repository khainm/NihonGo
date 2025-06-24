import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/auth_service.dart';
import 'api_endpoints.dart';

class ApiClient {
  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await _client.get(
      Uri.parse(ApiEndpoints.baseUrl + endpoint),
      headers: await _getHeaders(),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> post(String endpoint, dynamic data) async {
    final response = await _client.post(
      Uri.parse(ApiEndpoints.baseUrl + endpoint),
      headers: await _getHeaders(),
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> put(String endpoint, dynamic data) async {
    final response = await _client.put(
      Uri.parse(ApiEndpoints.baseUrl + endpoint),
      headers: await _getHeaders(),
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> delete(String endpoint) async {
    final response = await _client.delete(
      Uri.parse(ApiEndpoints.baseUrl + endpoint),
      headers: await _getHeaders(),
    );
    return _handleResponse(response);
  }

  Future<Map<String, String>> _getHeaders() async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final token = AuthService.getToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }
  }
}

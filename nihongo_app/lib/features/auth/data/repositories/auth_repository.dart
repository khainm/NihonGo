import 'package:nihongo_app/core/network/api_client.dart';
import 'package:nihongo_app/core/network/api_endpoints.dart';
import 'package:nihongo_app/features/auth/data/models/auth_request.dart';
import 'package:nihongo_app/features/auth/data/models/auth_response.dart';
import 'package:nihongo_app/shared/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final ApiClient _apiClient;
  
  AuthRepository(this._apiClient);
  
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
  
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }
  
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', user.toJson().toString());
  }
  
  Future<User> register(RegisterRequest request) async {
    final response = await _apiClient.post(
      ApiEndpoints.register,
      data: request.toJson(),
    );
    
    final authResponse = AuthResponse.fromJson(response);
    await saveToken(authResponse.token);
    return authResponse.user;
  }
  
  Future<User> login(LoginRequest request) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      data: request.toJson(),
    );
    
    final authResponse = AuthResponse.fromJson(response);
    await saveToken(authResponse.token);
    return authResponse.user;
  }
  
  Future<void> logout() async {
    await clearToken();
  }
  
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}

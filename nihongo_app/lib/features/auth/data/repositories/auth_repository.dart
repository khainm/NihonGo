import 'package:dartz/dartz.dart';
import 'package:nihongo_app/core/network/api_client.dart';
import 'package:nihongo_app/core/network/api_endpoints.dart';
import 'package:nihongo_app/core/error/failures.dart';
import 'package:nihongo_app/features/auth/data/models/auth_request.dart';
import 'package:nihongo_app/features/auth/data/models/auth_response.dart';
import 'package:nihongo_app/features/auth/domain/entities/user.dart';
import 'package:nihongo_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;
  
  AuthRepositoryImpl(this._apiClient);
  
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
    // Convert User entity to map for storage
    final userData = {
      'id': user.id,
      'name': user.name,
      'email': user.email,
    };
    await prefs.setString('user', userData.toString());
  }
  
  @override
  Future<Either<Failure, User>> register({
    String? name,
    required String email,
    required String password,
  }) async {
    try {
      final request = RegisterRequest(
        name: name,
        email: email,
        password: password,
      );
      
      final response = await _apiClient.post(
        ApiEndpoints.register,
        data: request.toJson(),
      );
      
      final authResponse = AuthResponse.fromJson(response);
      await saveToken(authResponse.token);
      
      // Convert data model to domain entity
      final user = User(
        id: authResponse.user.id,
        name: authResponse.user.name,
        email: authResponse.user.email,
      );
      
      return Right(user);
    } catch (e) {
      return Left(ServerFailure('Registration failed: ${e.toString()}'));
    }
  }
  
  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final request = LoginRequest(
        email: email,
        password: password,
      );
      
      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: request.toJson(),
      );
      
      final authResponse = AuthResponse.fromJson(response);
      await saveToken(authResponse.token);
      
      // Convert data model to domain entity
      final user = User(
        id: authResponse.user.id,
        name: authResponse.user.name,
        email: authResponse.user.email,
      );
      
      return Right(user);
    } catch (e) {
      return Left(ServerFailure('Login failed: ${e.toString()}'));
    }
  }
  
  Future<void> logout() async {
    await clearToken();
  }
  
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}

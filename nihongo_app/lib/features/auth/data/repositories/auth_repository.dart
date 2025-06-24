import 'package:dartz/dartz.dart';
import 'package:nihongo_app/core/network/api_client.dart';
import 'package:nihongo_app/core/network/api_endpoints.dart';
import 'package:nihongo_app/core/error/failures.dart';
import 'package:nihongo_app/features/auth/data/models/auth_request.dart';
import 'package:nihongo_app/features/auth/data/models/auth_response.dart';
import 'package:nihongo_app/features/auth/domain/entities/user.dart';
import 'package:nihongo_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:nihongo_app/core/services/auth_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;
  
  AuthRepositoryImpl(this._apiClient);
  
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
        request.toJson(),
      );
      
      final authResponse = AuthResponse.fromJson(response);
      
      // Save auth data using AuthService
      await AuthService.saveAuthData(
        token: authResponse.token,
        email: authResponse.user.email,
        name: authResponse.user.name,
      );
      
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
        request.toJson(),
      );
      
      final authResponse = AuthResponse.fromJson(response);
      
      // Save auth data using AuthService
      await AuthService.saveAuthData(
        token: authResponse.token,
        email: authResponse.user.email,
        name: authResponse.user.name,
      );
      
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
  
  @override
  Future<void> logout() async {
    await AuthService.clearAuthData();
  }
  
  @override
  Future<bool> isLoggedIn() async {
    return AuthService.isAuthenticated();
  }
}

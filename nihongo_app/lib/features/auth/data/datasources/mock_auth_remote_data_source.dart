import '../models/user_model.dart';
import '../../../../core/network/network_service.dart';
import '../../../../core/constants/api_constants.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> register({
    String? name,
    required String email,
    required String password,
  });

  Future<UserModel> login({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final NetworkService networkService;

  AuthRemoteDataSourceImpl({required this.networkService});

  @override
  Future<UserModel> register({
    String? name,
    required String email,
    required String password,
  }) async {
    final response = await networkService.post(
      url: ApiConstants.registerUrl,
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
    );

    return UserModel.fromJson(response);
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await networkService.post(
      url: ApiConstants.loginUrl,
      body: {
        'email': email,
        'password': password,
      },
    );

    return UserModel.fromJson(response);
  }
}

// Mock implementation for testing without backend
class MockAuthRemoteDataSource implements AuthRemoteDataSource {
  @override
  Future<UserModel> register({
    String? name,
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock successful response
    return UserModel(
      id: '1',
      name: name ?? 'User',
      email: email,
      token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock validation - for demo purposes, any email/password works
    // In real implementation, you would validate credentials
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email và mật khẩu không được để trống');
    }
    
    // Mock successful response
    return UserModel(
      id: '1',
      name: 'Học viên',
      email: email,
      token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
    );
  }
}

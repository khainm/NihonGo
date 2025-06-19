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

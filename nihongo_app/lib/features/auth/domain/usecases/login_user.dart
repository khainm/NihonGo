import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/error/failures.dart';

class LoginUser {
  final AuthRepository repository;

  LoginUser(this.repository);

  Future<Either<Failure, User>> call(LoginUserParams params) async {
    if (params.email.isEmpty) {
      return const Left(ValidationFailure('Email cannot be empty'));
    }
    
    if (params.password.isEmpty) {
      return const Left(ValidationFailure('Password cannot be empty'));
    }

    return await repository.login(
      email: params.email,
      password: params.password,
    );
  }
}

class LoginUserParams extends Equatable {
  final String email;
  final String password;

  const LoginUserParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

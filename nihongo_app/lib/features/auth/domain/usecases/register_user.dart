import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/error/failures.dart';

class RegisterUser {
  final AuthRepository repository;

  RegisterUser(this.repository);

  Future<Either<Failure, User>> call(RegisterUserParams params) async {
    if (params.email.isEmpty) {
      return const Left(ValidationFailure('Email cannot be empty'));
    }
    
    if (params.password.length < 8) {
      return const Left(ValidationFailure('Password must be at least 8 characters'));
    }

    return await repository.register(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class RegisterUserParams extends Equatable {
  final String? name;
  final String email;
  final String password;

  const RegisterUserParams({
    this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, password];
}

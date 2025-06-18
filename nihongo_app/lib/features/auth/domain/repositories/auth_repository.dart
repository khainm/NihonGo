import 'package:dartz/dartz.dart';
import '../entities/user.dart';
import '../../../../core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> register({
    String? name,
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });
}

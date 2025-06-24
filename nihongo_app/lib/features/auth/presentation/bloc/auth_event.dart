import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class RegisterUserEvent extends AuthEvent {
  final String? name;
  final String email;
  final String password;

  const RegisterUserEvent({
    this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, password];
}

class LoginUserEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginUserEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class CheckAuthenticationEvent extends AuthEvent {
  const CheckAuthenticationEvent();
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}

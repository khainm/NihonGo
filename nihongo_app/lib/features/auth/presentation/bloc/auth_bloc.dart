import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nihongo_app/features/auth/data/models/auth_request.dart';
import 'package:nihongo_app/features/auth/data/repositories/auth_repository.dart';
import 'package:nihongo_app/shared/models/user.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class RegisterButtonPressed extends AuthEvent {
  final String? name;
  final String email;
  final String password;
  
  const RegisterButtonPressed({
    this.name,
    required this.email,
    required this.password,
  });
  
  @override
  List<Object?> get props => [name, email, password];
}

class LoginButtonPressed extends AuthEvent {
  final String email;
  final String password;
  
  const LoginButtonPressed({
    required this.email,
    required this.password,
  });
  
  @override
  List<Object> get props => [email, password];
}

class LogoutButtonPressed extends AuthEvent {}

// States
abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;
  
  const AuthSuccess(this.user);
  
  @override
  List<Object> get props => [user];
}

class AuthFailure extends AuthState {
  final String error;
  
  const AuthFailure(this.error);
  
  @override
  List<Object> get props => [error];
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  
  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<RegisterButtonPressed>(_onRegisterButtonPressed);
    on<LoginButtonPressed>(_onLoginButtonPressed);
    on<LogoutButtonPressed>(_onLogoutButtonPressed);
  }
  
  void _onRegisterButtonPressed(
    RegisterButtonPressed event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      final request = RegisterRequest(
        name: event.name,
        email: event.email,
        password: event.password,
      );
      
      final user = await _authRepository.register(request);
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
  
  void _onLoginButtonPressed(
    LoginButtonPressed event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      final request = LoginRequest(
        email: event.email,
        password: event.password,
      );
      
      final user = await _authRepository.login(request);
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
  
  void _onLogoutButtonPressed(
    LogoutButtonPressed event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      await _authRepository.logout();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}

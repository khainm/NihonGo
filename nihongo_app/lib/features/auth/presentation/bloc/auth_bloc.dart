import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/register_user.dart';
import '../../domain/usecases/login_user.dart';
import '../../../../core/services/auth_service.dart';
import '../../domain/entities/user.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUser registerUser;
  final LoginUser loginUser;

  AuthBloc({
    required this.registerUser,
    required this.loginUser,
  }) : super(AuthInitial()) {
    on<RegisterUserEvent>(_onRegisterUser);
    on<LoginUserEvent>(_onLoginUser);
    on<CheckAuthenticationEvent>(_onCheckAuthentication);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onRegisterUser(
    RegisterUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await registerUser(RegisterUserParams(
      name: event.name,
      email: event.email,
      password: event.password,
    ));

    if (result.isLeft()) {
      final failure = result.fold((l) => l, (r) => null);
      emit(AuthError(failure!.message));
    } else {
      final user = result.fold((l) => null, (r) => r);
      try {
        // Save authentication data when registration is successful
        await AuthService.saveAuthData(
          token: user!.token ?? '',
          email: user.email,
          name: user.name,
        );
        emit(AuthAuthenticated(user));
      } catch (e) {
        emit(AuthError('Lỗi lưu thông tin đăng nhập: $e'));
      }
    }
  }

  Future<void> _onLoginUser(
    LoginUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await loginUser(LoginUserParams(
      email: event.email,
      password: event.password,
    ));

    if (result.isLeft()) {
      final failure = result.fold((l) => l, (r) => null);
      emit(AuthError(failure!.message));
    } else {
      final user = result.fold((l) => null, (r) => r);
      try {
        // Save authentication data when login is successful
        await AuthService.saveAuthData(
          token: user!.token ?? '',
          email: user.email,
          name: user.name,
        );
        emit(AuthAuthenticated(user));
      } catch (e) {
        emit(AuthError('Lỗi lưu thông tin đăng nhập: $e'));
      }
    }
  }

  Future<void> _onCheckAuthentication(
    CheckAuthenticationEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (AuthService.isAuthenticated()) {
      final token = AuthService.getToken();
      final email = AuthService.getUserEmail();
      final name = AuthService.getUserName();
      
      if (token != null && email != null) {
        // Create a user object from stored data
        final user = User(
          id: '',
          email: email,
          name: name,
          token: token,
        );
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    await AuthService.clearAuthData();
    emit(AuthUnauthenticated());
  }
}

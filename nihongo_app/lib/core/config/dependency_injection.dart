import 'package:get_it/get_it.dart';
import 'package:nihongo_app/core/network/api_client.dart';
import 'package:nihongo_app/features/auth/data/repositories/auth_repository.dart';
import 'package:nihongo_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:nihongo_app/features/auth/domain/usecases/register_user.dart';
import 'package:nihongo_app/features/auth/domain/usecases/login_user.dart';
import 'package:nihongo_app/features/auth/presentation/bloc/auth_bloc.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Core
  getIt.registerSingleton<ApiClient>(ApiClient());
  
  // Repositories
  getIt.registerSingleton<AuthRepository>(AuthRepositoryImpl(getIt<ApiClient>()));
  
  // Use Cases
  getIt.registerLazySingleton<RegisterUser>(() => RegisterUser(getIt<AuthRepository>()));
  getIt.registerLazySingleton<LoginUser>(() => LoginUser(getIt<AuthRepository>()));
  
  // BLoCs
  getIt.registerFactory<AuthBloc>(() => AuthBloc(
    registerUser: getIt<RegisterUser>(),
    loginUser: getIt<LoginUser>(),
  ));
}

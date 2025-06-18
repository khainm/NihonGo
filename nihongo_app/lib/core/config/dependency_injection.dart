import 'package:get_it/get_it.dart';
import 'package:nihongo_app/core/network/api_client.dart';
import 'package:nihongo_app/features/auth/data/repositories/auth_repository.dart';
import 'package:nihongo_app/features/auth/presentation/bloc/auth_bloc.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Core
  getIt.registerSingleton<ApiClient>(ApiClient());
  
  // Repositories
  getIt.registerSingleton<AuthRepository>(AuthRepository(getIt<ApiClient>()));
  
  // BLoCs
  getIt.registerFactory<AuthBloc>(() => AuthBloc(getIt<AuthRepository>()));
}

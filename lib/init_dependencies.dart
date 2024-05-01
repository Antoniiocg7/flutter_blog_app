
import 'package:blog_app/core/secrets/app_secrets.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnnonKey
  );
  serviceLocator.registerLazySingleton(() => supabase.client);
}

void _initAuth() {
  // USING <AuthRemoteDataSource> TO EXPECIFY THE TYPE IT IS RETURNING
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      // serviceLocator() FINDS THE CORRECT REFERENCE SO IT IS NOT NECESSARY TO USE THE <> type reference but recommended
      serviceLocator<SupabaseClient>()
    )
  );

  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      serviceLocator<AuthRemoteDataSource>()
    )
  );

  
  serviceLocator.registerFactory(
    () => UserSignUp(
      serviceLocator<AuthRepository>()
    )
  );

  // SINGLETON AS WE WANT ONLY 1 INSTANCE ON BLOC PRESENT FOR NOT LOSING STATE
  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      userSignUp: serviceLocator()
    )
  );
}
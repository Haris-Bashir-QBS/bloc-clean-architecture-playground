part of 'barrel.dart';

final sl = GetIt.instance;

Future<void> initializeDI() async {
  ///  core
  sl.registerLazySingleton(() => AppUserCubit());

  _initUser();

  /// ============================================= Daily News DI =================================
  /// Registering Remote Data Sources
  _initWeather();

  ///==================================== Auth DI ====================================

  await _initAuth();
}

void _initUser() {
  // sl.registerLazySingleton<UserRemoteDataSource>(
  //   () => UserRemoteDataSourceImpl(),
  // );
  //
  // sl.registerLazySingleton<UserRepository>(
  //   () => UserRepositoryImpl(sl<UserRemoteDataSource>()), //
  // );

  sl.registerLazySingleton(() => FetchUserProfileUseCase(sl<UserRepository>()));

  sl.registerLazySingleton(() => FetchUsersUseCase(sl<UserRepository>()));

  sl.registerFactory(
    () => UserBloc(sl<FetchUserProfileUseCase>(), sl<FetchUsersUseCase>()),
  );
}

void _initWeather() {
  /// Registering Remote Data Sources
  sl.registerLazySingleton<NewsRemoteDatasource>(
    () => NewsRemoteDatasourceImpl(),
  );

  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(sl<NewsRemoteDatasource>()),
  );

  sl.registerLazySingleton<FetchArticlesUseCase>(
    () => FetchArticlesUseCase(sl<NewsRepository>()),
  );
  sl.registerFactory(() => NewsArticleBloc(sl<FetchArticlesUseCase>()));

  /// Weather Forecast
  sl
    ..registerLazySingleton<WeatherRemoteDataSource>(
      () => WeatherRemoteDataSourceImpl(),
    )
    ..registerLazySingleton<WeatherRepository>(
      () => WeatherRepositoryImpl(remoteDataSource: sl()),
    )
    ..registerLazySingleton(() => GetWeatherUseCase(sl()))
    ..registerFactory(() => WeatherBloc(sl()));
}

Future<void> _initAuth() async {
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );

  sl
    ..registerLazySingleton(() => supabase.client)
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(supabaseClient: sl<SupabaseClient>()),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: sl()),
    )
    ..registerLazySingleton(() => SignUpUseCase(sl()))
    ..registerLazySingleton(() => SignInUseCase(sl()))
    ..registerLazySingleton(() => CurrentUserUsecase(sl()))
    ..registerLazySingleton(() => SignOutUsecase(sl()))
    ..registerFactory(
      () => AuthBloc(
        signUpUseCase: sl<SignUpUseCase>(),
        signInUseCase: sl<SignInUseCase>(),
        currentUserUsecase: sl<CurrentUserUsecase>(),
        authUserCubit: sl<AppUserCubit>(),
        signOutUsecase: sl<SignOutUsecase>(),
      ),
    );
}

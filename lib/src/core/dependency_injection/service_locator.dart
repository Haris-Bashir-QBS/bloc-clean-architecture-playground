import 'package:bloc_api_integration/src/features/daily_news/data/datasources/remote/news_remote_datasource.dart';
import 'package:bloc_api_integration/src/features/daily_news/domain/usecases/fetch_articles_usecase.dart';
import 'package:bloc_api_integration/src/features/user_profile/domain/repositories/user_repository.dart';
import 'package:bloc_api_integration/src/features/weather_forecast/data/datasources/remote/weather_remote_datasource_impl.dart';
import 'package:bloc_api_integration/src/features/weather_forecast/domain/usecases/get_weather_usecase.dart';
import 'package:get_it/get_it.dart';
import '../../features/daily_news/data/repositories/article_repository_impl.dart';
import '../../features/daily_news/domain/repositories/article_repository.dart';
import '../../features/daily_news/presentation/bloc/news_article_bloc.dart';
import '../../features/user_profile/data/datasources/user_remote_data_source.dart';
import '../../features/user_profile/data/repositories/users_repository_impl.dart';
import '../../features/user_profile/domain/usecases/fetch_users_usecase.dart';
import '../../features/user_profile/domain/usecases/get_user_profile_usecase.dart';
import '../../features/user_profile/presentation/bloc/user_bloc.dart';
import '../../features/weather_forecast/data/datasources/remote/weather_remote_datasource.dart';
import '../../features/weather_forecast/data/repositories/weather_repository_impl.dart';
import '../../features/weather_forecast/domain/repositories/weather_repository.dart';
import '../../features/weather_forecast/presentation/bloc/weather_bloc.dart';

final sl = GetIt.instance;

void initializeDI() {
  // 1. Register UserRemoteDataSource first
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      sl<UserRemoteDataSource>(),
    ), // Fresh instance each time
  );

  // 3. Register Use Cases that depend on UserRepository
  sl.registerLazySingleton(() => FetchUserProfileUseCase(sl<UserRepository>()));

  sl.registerLazySingleton(() => FetchUsersUseCase(sl<UserRepository>()));

  // 4. Register Bloc
  sl.registerFactory(
    () => UserBloc(sl<FetchUserProfileUseCase>(), sl<FetchUsersUseCase>()),
  );

  /// News DI
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

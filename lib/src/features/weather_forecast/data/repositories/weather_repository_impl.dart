import 'package:bloc_api_integration/src/features/weather_forecast/domain/entities/weather_entity.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../network/api_exceptions.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/remote/weather_remote_datasource.dart';
import '../datasources/remote/weather_remote_datasource_impl.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;

  WeatherRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, WeatherEntity>> getWeather(String cityName) async {
    try {
      final data = await remoteDataSource.getWeather(cityName);
      return Right(data);
    } catch (e) {
      return Left(
        ServerException(
          message: e.toString(),
          requestOptions: RequestOptions(),
        ),
      );
    }
  }
}

import 'package:bloc_api_integration/src/features/weather_forecast/domain/entities/weather_entity.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../network/api_exceptions.dart';
import '../../../../network/error_handler.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/remote/weather_remote_datasource.dart';
import '../models/weather_model.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;

  WeatherRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, WeatherEntity>> getWeather(String cityName) async {
    try {
      final WeatherModel data = await remoteDataSource.getWeather(cityName);
      return Right(data);
    } catch (error) {
      if (error is DioException) {
        return Left(ApiErrorHandler.handleError(error));
      } else {
        return Left(UnknownException());
      }
    }
  }
}

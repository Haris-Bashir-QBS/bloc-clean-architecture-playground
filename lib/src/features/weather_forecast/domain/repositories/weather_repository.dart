import 'package:bloc_api_integration/src/features/weather_forecast/domain/entities/weather_entity.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../network/api_exceptions.dart';

abstract interface class WeatherRepository {
  Future<Either<Failure, WeatherEntity>> getWeather(String cityName);
}

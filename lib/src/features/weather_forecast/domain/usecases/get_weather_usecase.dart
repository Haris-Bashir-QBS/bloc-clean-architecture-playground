import 'package:bloc_api_integration/src/core/use_cases/use_case.dart';
import 'package:bloc_api_integration/src/features/weather_forecast/domain/entities/weather_entity.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../network/api_exceptions.dart';
import '../repositories/weather_repository.dart';

class GetWeatherUseCase implements UseCase<WeatherEntity, String> {
  final WeatherRepository repository;

  GetWeatherUseCase(this.repository);

  @override
  Future<Either<Failure, WeatherEntity>> call(String cityName) {
    return repository.getWeather(cityName);
  }
}

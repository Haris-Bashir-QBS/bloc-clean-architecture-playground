import 'dart:async';
import 'package:bloc_api_integration/src/core/common/transformers/debounce_transformer.dart';
import 'package:bloc_api_integration/src/features/weather_forecast/domain/usecases/get_weather_usecase.dart';
import 'package:bloc_api_integration/src/features/weather_forecast/presentation/bloc/weather_event.dart';
import 'package:bloc_api_integration/src/features/weather_forecast/presentation/bloc/weather_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetWeatherUseCase getWeather;

  WeatherBloc(this.getWeather) : super(WeatherInitial()) {
    on<FetchWeatherEvent>(
      fetchWeather,
      transformer: debounce(Duration(milliseconds: 400)),
    );
  }

  FutureOr<void> fetchWeather(event, emit) async {
    emit(WeatherLoading());
    final result = await getWeather(event.cityName);
    result.fold(
      (failure) => emit(WeatherError(failure.message)),
      (weather) => emit(WeatherLoaded(weather)),
    );
  }
}

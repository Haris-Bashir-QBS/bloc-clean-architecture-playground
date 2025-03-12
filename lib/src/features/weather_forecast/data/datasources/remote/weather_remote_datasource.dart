import '../../models/weather_model.dart';

abstract interface class WeatherRemoteDataSource {
  Future<WeatherModel> getWeather(String cityName);
}

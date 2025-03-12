import 'package:bloc_api_integration/src/features/weather_forecast/data/datasources/remote/weather_remote_datasource.dart';
import 'package:bloc_api_integration/src/features/weather_forecast/data/models/weather_model.dart';
import 'package:bloc_api_integration/src/network/dio_client.dart';

import '../../../../../network/api_endpoints.dart';

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  WeatherRemoteDataSourceImpl();

  @override
  Future<WeatherModel> getWeather(String cityName) async {
    final res = await DioClient().get(
      endpoint: 'forecast',
      customBaseUrl: 'https://api.openweathermap.org/data/2.5/',
      queryParams: {'q': cityName, 'APPID': ApiEndPoints.weatherApiSecret},
    );

    final data = res.data;
    if (data['cod'] != '200') {
      throw Exception('An unexpected error occurred');
    }

    final currentWeatherData = data['list'][0];

    return WeatherModel.fromJson(currentWeatherData);
  }
}

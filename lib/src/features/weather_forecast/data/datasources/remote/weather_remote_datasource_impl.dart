import 'package:bloc_api_integration/src/features/weather_forecast/data/datasources/remote/weather_remote_datasource.dart';
import 'package:bloc_api_integration/src/features/weather_forecast/data/models/weather_model.dart';
import 'package:bloc_api_integration/src/network/dio_client.dart';

import '../../../../../network/api_endpoints.dart';
import '../../../../../network/response_validator.dart';

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  WeatherRemoteDataSourceImpl();

  @override
  Future<WeatherModel> getWeather(String cityName) async {
    final res = await DioClient().get(
      endpoint: 'forecast',
      customBaseUrl: 'https://api.openweathermap.org/data/2.5/',
      queryParams: {'q': cityName, 'APPID': ApiEndPoints.weatherApiSecret},
    );

    final data = ResponseValidator.validateResponse(res);

    final currentWeatherData = data['list'][0];

    return WeatherModel.fromJson(currentWeatherData);
  }
}

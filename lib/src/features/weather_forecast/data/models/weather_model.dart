import 'package:bloc_api_integration/src/features/weather_forecast/domain/entities/weather_entity.dart';

class WeatherModel extends WeatherEntity {
  WeatherModel({
    required super.temperature,
    required super.condition,
    required super.windSpeed,
    required super.humidity,
    required super.pressure,
  });

  /// Convert JSON to Model (DTO)
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temperature: json['main']['temp'].toDouble(),
      condition: json['weather'][0]['main'],
      windSpeed: json['wind']['speed'].toDouble(),
      humidity: json['main']['humidity'],
      pressure: json['main']['pressure'],
    );
  }

  /// Convert Model to JSON (optional if needed)
  Map<String, dynamic> toJson() {
    return {
      'main': {'temp': temperature, 'humidity': humidity, 'pressure': pressure},
      'weather': [
        {'main': condition},
      ],
      'wind': {'speed': windSpeed},
    };
  }
}

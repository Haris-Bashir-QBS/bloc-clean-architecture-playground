import 'package:flutter/material.dart';
import '../../domain/entities/weather_entity.dart';
import '../widgets/additional_info_item.dart';
import '../widgets/weather_card.dart';

class WeatherDisplay extends StatelessWidget {
  final WeatherEntity weather;
  final String city;

  const WeatherDisplay({super.key, required this.weather, required this.city});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            city,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: double.infinity,
            child: WeatherCard(weather: weather),
          ),
          const SizedBox(height: 20),

          // Additional Information
          const Text(
            'Additional Information',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AdditionalInfoItem(
                icon: Icons.water_drop,
                label: 'Humidity',
                value: weather.humidity.toString(),
              ),
              AdditionalInfoItem(
                icon: Icons.air,
                label: 'Wind Speed',
                value: weather.windSpeed.toString(),
              ),
              AdditionalInfoItem(
                icon: Icons.beach_access,
                label: 'Pressure',
                value: weather.pressure.toString(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

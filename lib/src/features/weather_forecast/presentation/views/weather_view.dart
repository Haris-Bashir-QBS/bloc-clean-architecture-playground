import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/weather_entity.dart';
import '../bloc/weather_bloc.dart';
import '../bloc/weather_event.dart';
import '../bloc/weather_state.dart';
import '../widgets/additional_info_item.dart';
import '../widgets/weather_card.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    getWeatherDetails();
    super.initState();
  }

  Future<void> getWeatherDetails() async {
    context.read<WeatherBloc>().add(FetchWeatherEvent("London"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              context.read<WeatherBloc>().add(FetchWeatherEvent("London"));
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (state is WeatherLoaded) {
            return WeatherDisplay(weather: state.weather);
          } else if (state is WeatherError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class WeatherDisplay extends StatelessWidget {
  final WeatherEntity weather;

  const WeatherDisplay({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main Weather Card
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

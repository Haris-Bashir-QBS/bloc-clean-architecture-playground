import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/weather_bloc.dart';
import '../bloc/weather_event.dart';
import '../bloc/weather_state.dart';
import '../widgets/weather_display_widget.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final cityTextEditingController = TextEditingController();
  @override
  void initState() {
    //getWeatherDetails();
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
      body: Column(
        children: [
          _searchField(),
          SizedBox(height: 20),
          _weatherDetailsWidget(),
        ],
      ),
    );
  }

  Widget _weatherDetailsWidget() {
    return Expanded(
      child: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          return switch (state) {
            WeatherLoading() => const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
            WeatherLoaded(weather: final weather) => WeatherDisplay(
              weather: weather,
              city: cityTextEditingController.text.trim(),
            ),
            WeatherError(message: final message) => Center(
              child: Text(message),
            ),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }

  Widget _searchField() {
    return TextField(
      controller: cityTextEditingController,
      onChanged: (value) {
        context.read<WeatherBloc>().add(FetchWeatherEvent(value));
      },
      decoration: InputDecoration(
        hintText: "Enter city name",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: const Icon(Icons.search),
      ),
    );
  }
}

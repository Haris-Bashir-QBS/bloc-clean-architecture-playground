// Debounce transformer

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../features/weather_forecast/presentation/bloc/weather_event.dart';

EventTransformer<FetchWeatherEvent> debounce(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

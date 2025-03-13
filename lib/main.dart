import 'package:bloc_api_integration/src/core/dependency_injection/service_locator.dart';
import 'package:bloc_api_integration/src/features/daily_news/presentation/bloc/news_article_bloc.dart';
import 'package:bloc_api_integration/src/features/user_profile/presentation/bloc/user_bloc.dart';
import 'package:bloc_api_integration/src/features/weather_forecast/presentation/bloc/weather_bloc.dart';
import 'package:bloc_api_integration/src/features/weather_forecast/presentation/views/weather_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  initializeDI();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<UserBloc>()),
        BlocProvider(create: (_) => sl<NewsArticleBloc>()),
        BlocProvider(create: (_) => sl<WeatherBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      // home:  UserProfileView(userId: "2"),
      // home: UsersListScreen(),
      // home: ArticlesListingScreen(),
      home: WeatherScreen(),
    );
  }
}

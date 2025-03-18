import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router/app_routes.dart' show AppRoutes;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => context.goNamed(AppRoutes.settings),
          ),
        ],
      ),
      body: Center(child: Text("Welcome to Home!")),
    );
  }
}

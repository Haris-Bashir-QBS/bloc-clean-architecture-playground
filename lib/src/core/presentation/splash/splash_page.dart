import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../features/auth/presentation/bloc/auth_event.dart';
import '../../../features/auth/presentation/bloc/auth_state.dart';
import '../../common/cubits/app_user_cubit.dart';
import '../../common/cubits/app_user_state.dart';
import '../../router/app_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    log("Checking Auth Session...");
    context.read<AuthBloc>().add(AuthIsUserLoggedInEvent());
  }

  void _navigateBasedOnAuthState() {
    final state = context.read<AppUserCubit>().state;
    Future.delayed(Duration(seconds: 2), () {
      if (!mounted) return;

      if (state is AppUserLoggedIn) {
        log("✅ User is logged in: Navigating to Home");
        context.goNamed(AppRoutes.home);
      } else {
        log("❌ User is NOT logged in: Navigating to Login ${state}");
        context.goNamed(AppRoutes.signIn);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          log("🔹 AuthBloc Success: Checking session in AppUserCubit...");

          _navigateBasedOnAuthState();
        } else if (state is AuthFailure) {
          log("❌ AuthBloc Failure: Navigating to Login");
          context.goNamed(AppRoutes.signIn);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.article, size: 100, color: Colors.blueAccent),
              SizedBox(height: 20),
              Text(
                'BlogSpace',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

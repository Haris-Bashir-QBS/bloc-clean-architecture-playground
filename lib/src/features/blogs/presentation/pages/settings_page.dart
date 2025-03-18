import 'package:bloc_api_integration/src/core/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/cubits/app_user_cubit.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart' show AuthSignOutEvent;
import '../../../auth/presentation/bloc/auth_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSignedOut) {
          context.pop();
          context.goNamed(AppRoutes.signIn);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Settings")),
        body: Center(
          child: ElevatedButton(
            onPressed: () => _showLogoutDialog(context),
            child: Text("Logout"),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm Logout"),
          content: Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close dialog
              child: Text("No"),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(AuthSignOutEvent());
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }
}

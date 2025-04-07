import 'package:bloc_api_integration/src/core/router/app_routes.dart';
import 'package:bloc_api_integration/src/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart' show AuthSignOutEvent;
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../../widgets/dialog.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSignedOut) {
          context.pop();
          showSnackBar(context, content: "Sign Out Successfully");
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
    showConfirmationDialog(
      context: context,
      title: "Confirm Logout",
      content: "Are you sure you want to logout?",
      confirmText: "Yes",
      cancelText: "No",
      onConfirm: () => context.read<AuthBloc>().add(AuthSignOutEvent()),
    );
  }
}

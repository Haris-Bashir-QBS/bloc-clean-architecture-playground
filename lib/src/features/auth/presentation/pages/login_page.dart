import 'package:bloc_api_integration/src/core/router/app_routes.dart';
import 'package:bloc_api_integration/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bloc_api_integration/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:bloc_api_integration/src/features/auth/presentation/bloc/auth_state.dart';
import 'package:bloc_api_integration/src/features/auth/presentation/widgets/auth_field.dart';
import 'package:bloc_api_integration/src/features/auth/presentation/widgets/auth_gradient_burtton.dart';
import 'package:bloc_api_integration/src/widgets/snackbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_palette.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const LoginPage());

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              context.goNamed(AppRoutes.home);
            } else if (state is AuthFailure) {
              showSnackBar(context, content: state.message);
            }
          },
          builder: (context, state) {
            return Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _signInText(),
                  const SizedBox(height: 30),
                  emailTextField(),
                  const SizedBox(height: 15),
                  _passwordTextField(),
                  const SizedBox(height: 20),
                  _signInButton(state),
                  const SizedBox(height: 20),
                  signupNavigationText(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget signupNavigationText() {
    return RichText(
      text: TextSpan(
        text: 'Don\'t have an account? ',
        style: Theme.of(context).textTheme.titleMedium,
        children: [
          TextSpan(
            text: 'Sign Up',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppPallete.gradient2,
              fontWeight: FontWeight.bold,
            ),
            recognizer:
                TapGestureRecognizer()
                  ..onTap = () {
                    context.goNamed(AppRoutes.signUp);
                  },
          ),
        ],
      ),
    );
  }

  Widget _signInButton(AuthState state) {
    return AuthGradientButton(
      buttonText: 'Sign in',
      showLoader: state is AuthLoading,
      onPressed: () {
        if (formKey.currentState!.validate()) {
          context.read<AuthBloc>().add(
            AuthSignInEvent(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            ),
          );
        }
      },
    );
  }

  AuthField _passwordTextField() {
    return AuthField(
      hintText: 'Password',
      controller: passwordController,
      isObscureText: true,
    );
  }

  AuthField emailTextField() {
    return AuthField(hintText: 'Email', controller: emailController);
  }

  Text _signInText() {
    return const Text(
      'Sign In.',
      style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

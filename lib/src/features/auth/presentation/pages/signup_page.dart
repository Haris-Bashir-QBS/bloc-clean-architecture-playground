import 'package:bloc_api_integration/src/core/router/app_routes.dart';
import 'package:bloc_api_integration/src/core/theme/app_palette.dart';
import 'package:bloc_api_integration/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bloc_api_integration/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:bloc_api_integration/src/features/auth/presentation/bloc/auth_state.dart';
import 'package:bloc_api_integration/src/features/auth/presentation/widgets/auth_field.dart';
import 'package:bloc_api_integration/src/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../widgets/snackbar.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (BuildContext context, AuthState state) {
              if (state is AuthFailure) {
                showSnackBar(context, content: state.message);
              }
            },
            builder: (BuildContext context, AuthState state) {
              return _signupForm(state);
            },
          ),
        ),
      ),
    );
  }

  Form _signupForm(AuthState state) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(height: 80),
          _signupText(),
          SizedBox(height: 30),
          _nameTextField(),
          SizedBox(height: 15),
          _emailTextField(),
          SizedBox(height: 15),
          _passwordController(),
          SizedBox(height: 15),
          _confirmPasswordController(),
          SizedBox(height: 15),
          _signupButton(state),
          SizedBox(height: 15),
          _signInText(),
          SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _signupButton(AuthState state) {
    return AuthGradientButton(
      buttonText: "Sign Up",
      showLoader: state is AuthLoading,
      onPressed: () {
        _onSignUp();
      },
    );
  }

  void _onSignUp() {
    if (formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthSignUpEvent(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        ),
      );
    }
  }

  Widget _signInText() {
    return RichText(
      text: TextSpan(
        text: "Already have an account? ",
        style: Theme.of(context).textTheme.titleMedium,
        children: [
          TextSpan(
            text: "Sign In",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppPallete.gradient2,
              fontWeight: FontWeight.bold,
            ),
            recognizer:
                TapGestureRecognizer()
                  ..onTap = () {
                    context.goNamed(AppRoutes.signIn);
                  },
          ),
        ],
      ),
    );
  }

  Text _signupText() {
    return Text(
      "Sign up.",
      style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
    );
  }

  AuthField _confirmPasswordController() {
    return AuthField(
      hintText: "Confirm Password",
      controller: confirmPasswordController,
      isObscureText: true,
    );
  }

  Widget _passwordController() {
    return AuthField(
      hintText: "Password",
      controller: passwordController,
      isObscureText: true,
    );
  }

  Widget _emailTextField() {
    return AuthField(hintText: "Email", controller: emailController);
  }

  Widget _nameTextField() {
    return AuthField(hintText: "Name", controller: nameController);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}

import 'package:bloc_api_integration/src/features/auth/presentation/pages/login_page.dart';
import 'package:bloc_api_integration/src/features/auth/presentation/pages/signup_page.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/signin',
  routes: [
    GoRoute(
      path: '/signin',
      name: AppRoutes.signIn,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/signup',
      name: AppRoutes.signUp,
      builder: (context, state) => const SignupPage(),
    ),
  ],
);

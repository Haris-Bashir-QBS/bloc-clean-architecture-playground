import 'package:bloc_api_integration/src/core/presentation/splash/splash_page.dart';
import 'package:bloc_api_integration/src/features/auth/presentation/pages/login_page.dart';
import 'package:bloc_api_integration/src/features/auth/presentation/pages/signup_page.dart';
import 'package:bloc_api_integration/src/features/blogs/domain/entities/blog_entity.dart';
import 'package:bloc_api_integration/src/features/blogs/presentation/pages/add_new_blog.dart';
import 'package:bloc_api_integration/src/features/blogs/presentation/pages/blog_view_page.dart';
import 'package:bloc_api_integration/src/features/blogs/presentation/pages/home_page.dart';
import 'package:go_router/go_router.dart';
import '../../features/blogs/presentation/pages/settings_page.dart';
import 'app_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: AppRoutes.splash,
      builder: (context, state) => SplashPage(),
    ),
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
    GoRoute(
      path: '/home',
      name: AppRoutes.home,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/settings',
      name: AppRoutes.settings,
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: '/add_new_blog',
      name: AppRoutes.addNewBlog,
      builder: (context, state) => const AddNewBlogPage(),
    ),
    GoRoute(
      path: '/blog_viewer',
      name: AppRoutes.blogViewer,
      builder: (context, state) {
        final blog = state.extra as BlogEntity;
        return BlogViewerPage(blog: blog);
      },
    ),
  ],
);

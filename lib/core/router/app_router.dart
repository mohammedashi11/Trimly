import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/signup_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../theme/app_text_styles.dart';

/// Route paths used across the app.
abstract final class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
}

/// Fade-through page transition (250–300ms) used app-wide.
CustomTransitionPage<T> fadePage<T>({
  required Widget child,
  required GoRouterState state,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 280),
    reverseTransitionDuration: const Duration(milliseconds: 280),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child,
      );
    },
  );
}

/// App-wide router. Screens register their routes here phase by phase.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (context, state) =>
            fadePage(child: const SplashScreen(), state: state),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        pageBuilder: (context, state) =>
            fadePage(child: const OnboardingScreen(), state: state),
      ),
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (context, state) =>
            fadePage(child: const LoginScreen(), state: state),
      ),
      GoRoute(
        path: AppRoutes.signup,
        pageBuilder: (context, state) =>
            fadePage(child: const SignupScreen(), state: state),
      ),
      GoRoute(
        path: AppRoutes.home,
        pageBuilder: (context, state) => fadePage(
          // Placeholder until the home feature lands in the next phase.
          child: Scaffold(
            body: Center(
              child: Text('Home', style: AppTextStyles.headlineMd),
            ),
          ),
          state: state,
        ),
      ),
    ],
  );
});

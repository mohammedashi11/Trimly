import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/signup_screen.dart';
import '../../features/favorites/presentation/favorites_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/shell/presentation/app_shell.dart';
import '../../features/shops/presentation/all_shops_screen.dart';
import '../../features/shops/presentation/home_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../theme/app_text_styles.dart';

/// Route paths used across the app.
abstract final class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String bookings = '/bookings';
  static const String favorites = '/favorites';
  static const String profile = '/profile';
  static const String allShops = '/shops';

  /// Shop detail base path; append `/<shopId>`.
  static const String shop = '/shop';
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
        path: AppRoutes.allShops,
        pageBuilder: (context, state) =>
            fadePage(child: const AllShopsScreen(), state: state),
      ),
      GoRoute(
        path: '${AppRoutes.shop}/:id',
        pageBuilder: (context, state) => fadePage(
          // Placeholder until the shop detail feature lands next phase.
          child: Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Text(
                state.pathParameters['id'] ?? '',
                style: AppTextStyles.headlineMd,
              ),
            ),
          ),
          state: state,
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                pageBuilder: (context, state) =>
                    fadePage(child: const HomeScreen(), state: state),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.bookings,
                pageBuilder: (context, state) => fadePage(
                  // Placeholder until the bookings feature lands in Phase 6.
                  child: Scaffold(
                    appBar: AppBar(title: const Text('My Bookings')),
                    body: Center(
                      child: Text(
                        'Your appointments will live here.',
                        style: AppTextStyles.bodyMd,
                      ),
                    ),
                  ),
                  state: state,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.favorites,
                pageBuilder: (context, state) =>
                    fadePage(child: const FavoritesScreen(), state: state),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                pageBuilder: (context, state) => fadePage(
                  // Placeholder until the profile feature lands in Phase 6.
                  child: Scaffold(
                    appBar: AppBar(title: const Text('Profile')),
                    body: Center(
                      child: Text(
                        'Your profile will live here.',
                        style: AppTextStyles.bodyMd,
                      ),
                    ),
                  ),
                  state: state,
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

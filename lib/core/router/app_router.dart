import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../widgets/trimly_logo.dart';

/// Route paths used across the app.
abstract final class AppRoutes {
  static const String splash = '/';
}

/// App-wide router. Screens register their routes here phase by phase.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const Scaffold(
          body: Center(child: TrimlyLogo(size: 96, glow: true)),
        ),
      ),
    ],
  );
});

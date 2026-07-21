import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trimly/core/providers/shared_preferences_provider.dart';
import 'package:trimly/core/theme/app_theme.dart';

/// Pumps [child] inside a themed app with a single-route [GoRouter] and the
/// mock repositories wired up against in-memory [SharedPreferences].
Future<void> pumpScreen(
  WidgetTester tester,
  Widget child, {
  Map<String, Object> prefs = const {},
}) async {
  // Tall phone-like viewport so full screens are laid out in tests.
  tester.view.physicalSize = const Size(600, 2200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  SharedPreferences.setMockInitialValues(prefs);
  final sharedPreferences = await SharedPreferences.getInstance();

  Widget blank(BuildContext context, GoRouterState state) =>
      const Scaffold(body: SizedBox());

  final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => child),
      // Navigation targets reached from the screens under test.
      GoRoute(path: '/home', builder: blank),
      GoRoute(path: '/login', builder: blank),
      GoRoute(path: '/shops', builder: blank),
      GoRoute(path: '/booking-confirmation', builder: blank),
      GoRoute(
        path: '/shop/:id',
        builder: blank,
        routes: [GoRoute(path: 'book', builder: blank)],
      ),
    ],
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: MaterialApp.router(
        theme: AppTheme.dark,
        routerConfig: router,
      ),
    ),
  );
}

/// Pumps enough frames for the mock repositories (300–600ms latency)
/// to resolve.
Future<void> settleMockLatency(WidgetTester tester) async {
  await tester.pump(const Duration(milliseconds: 700));
  await tester.pump(const Duration(milliseconds: 700));
}

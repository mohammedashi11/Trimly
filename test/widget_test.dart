import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trimly/core/constants/app_assets.dart';
import 'package:trimly/core/providers/shared_preferences_provider.dart';
import 'package:trimly/main.dart';

void main() {
  testWidgets('app boots and shows the Trimly mark', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const TrimlyApp(),
      ),
    );
    await tester.pump();

    expect(find.image(const AssetImage(AppAssets.logo)), findsOneWidget);

    // Let the splash timer fire and the router settle on the next screen.
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
  });
}

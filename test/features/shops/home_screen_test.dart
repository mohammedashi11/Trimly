import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trimly/core/widgets/skeleton.dart';
import 'package:trimly/features/shops/presentation/home_screen.dart';
import 'package:trimly/features/shops/presentation/widgets/barber_tile.dart';
import 'package:trimly/features/shops/presentation/widgets/shop_card.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('home shows skeletons, then shops and barbers', (tester) async {
    await pumpScreen(tester, const HomeScreen());

    // Loading state renders shimmer skeletons, not spinners.
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.byType(Skeleton), findsWidgets);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await settleMockLatency(tester);

    expect(find.text('Top Rated Near You'), findsOneWidget);
    expect(find.text('Popular Barbers'), findsOneWidget);
    expect(find.byType(ShopCard), findsWidgets);
    expect(find.byType(BarberTile), findsWidgets);
  });

  testWidgets('search filters shops and barbers live', (tester) async {
    await pumpScreen(tester, const HomeScreen());
    await settleMockLatency(tester);

    await tester.enterText(find.byType(TextFormField).first, 'Kings');
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Kings Cut Lounge'), findsOneWidget);
    expect(find.text('Urban Blade Studio'), findsNothing);
    // Barbers narrow down to the matching shop's team.
    expect(find.text('David Chen'), findsOneWidget);
    expect(find.text('Kai Nakamura'), findsNothing);
  });

  testWidgets('category chips filter the catalogue', (tester) async {
    await pumpScreen(tester, const HomeScreen());
    await settleMockLatency(tester);

    // Fade & Fellow offers no coloring services.
    await tester.tap(find.text('Coloring'));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Fade & Fellow'), findsNothing);
    expect(find.text('Kings Cut Lounge'), findsOneWidget);
  });
}

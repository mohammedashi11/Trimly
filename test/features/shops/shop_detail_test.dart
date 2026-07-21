import 'package:flutter_test/flutter_test.dart';
import 'package:trimly/features/shops/presentation/shop_detail_screen.dart';
import 'package:trimly/features/shops/presentation/widgets/service_tile.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('detail renders shop info and running total', (tester) async {
    await pumpScreen(
      tester,
      const ShopDetailScreen(shopId: 'vintage-gent'),
    );
    await settleMockLatency(tester);

    expect(find.text('The Vintage Gent'), findsOneWidget);
    expect(find.text('OPEN NOW'), findsOneWidget);
    expect(find.text('123 Grooming St, Downtown'), findsOneWidget);
    expect(find.text('Total: \$0'), findsOneWidget);

    // Selecting services updates the sticky bar total.
    await tester.tap(find.byType(ServiceTile).first);
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Total: \$40'), findsOneWidget);

    // Deselecting brings it back to zero.
    await tester.tap(find.byType(ServiceTile).first);
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Total: \$0'), findsOneWidget);
  });

  testWidgets('tabs switch between services, gallery and reviews',
      (tester) async {
    await pumpScreen(
      tester,
      const ShopDetailScreen(shopId: 'vintage-gent'),
    );
    await settleMockLatency(tester);

    expect(find.byType(ServiceTile), findsWidgets);

    await tester.tap(find.text('Reviews'));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(ServiceTile), findsNothing);
    expect(find.text('Paul Whitmore'), findsOneWidget);
  });
}

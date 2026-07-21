import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trimly/features/bookings/domain/time_slots.dart';
import 'package:trimly/features/bookings/presentation/booking_screen.dart';
import 'package:trimly/features/shops/data/shop_seed_data.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('full booking flow persists a confirmed booking',
      (tester) async {
    final shop = ShopSeedData.shops.first;
    final service = shop.services.first;

    await pumpScreen(
      tester,
      BookingScreen(
        shopId: shop.id,
        args: BookingFlowArgs(services: [service]),
      ),
    );
    await settleMockLatency(tester);

    expect(find.text('Select Barber'), findsOneWidget);
    expect(find.text('Select Date'), findsOneWidget);
    expect(find.text('Available Times'), findsOneWidget);
    expect(find.text(service.name), findsOneWidget);

    // Find a day (today or tomorrow) with an open slot for the default
    // barber, matching what the grid displays.
    final barber = shop.barbers.first;
    var day = DateTime.now();
    var slots = TimeSlots.forDay(
      shopId: shop.id,
      barberId: barber.id,
      day: day,
    ).where((s) => s.available);
    if (slots.isEmpty) {
      day = day.add(const Duration(days: 1));
      await tester.tap(find.text('${day.day}'));
      await tester.pump(const Duration(milliseconds: 400));
      slots = TimeSlots.forDay(
        shopId: shop.id,
        barberId: barber.id,
        day: day,
      ).where((s) => s.available);
    }
    final slotLabel = DateFormat('hh:mm a').format(slots.first.dateTime);

    await tester.ensureVisible(find.text(slotLabel));
    await tester.tap(find.text(slotLabel));
    await tester.pump(const Duration(milliseconds: 400));

    await tester.tap(find.text('CONTINUE'));
    await settleMockLatency(tester);

    // The booking was written to local storage.
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('trimly.bookings');
    expect(raw, isNotNull);
    expect(raw, contains(shop.id));
    expect(raw, contains(service.id));
    expect(raw, contains('confirmed'));
  });
}

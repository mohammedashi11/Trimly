import 'package:flutter_test/flutter_test.dart';
import 'package:trimly/features/bookings/domain/time_slots.dart';

void main() {
  final day = DateTime(2026, 8, 3);
  final beforeOpen = DateTime(2026, 8, 1, 8);

  group('slot generation', () {
    test('produces a half-hour grid across opening hours', () {
      final slots = TimeSlots.forDay(
        shopId: 'kings-cut',
        barberId: 'kings-cut-b1',
        day: day,
        now: beforeOpen,
      );

      expect(
        slots.length,
        (TimeSlots.closingHour - TimeSlots.openingHour) * 2,
      );
      expect(slots.first.dateTime.hour, TimeSlots.openingHour);
      expect(slots.first.dateTime.minute, 0);
      expect(slots.last.dateTime.hour, TimeSlots.closingHour - 1);
      expect(slots.last.dateTime.minute, 30);
    });

    test('is deterministic for the same shop, barber and day', () {
      List<TimeSlot> generate() => TimeSlots.forDay(
            shopId: 'vintage-gent',
            barberId: 'vintage-gent-b2',
            day: day,
            now: beforeOpen,
          );

      expect(generate(), generate());
    });

    test('marks a portion of future slots unavailable', () {
      final slots = TimeSlots.forDay(
        shopId: 'urban-blade',
        barberId: 'urban-blade-b1',
        day: day,
        now: beforeOpen,
      );

      final unavailable = slots.where((s) => !s.available);
      expect(unavailable, isNotEmpty);
      expect(unavailable.length, lessThan(slots.length));
    });

    test('slots in the past are never available', () {
      final now = DateTime(2026, 8, 3, 14, 15);
      final slots = TimeSlots.forDay(
        shopId: 'kings-cut',
        barberId: 'kings-cut-b1',
        day: day,
        now: now,
      );

      final past = slots.where((s) => !s.dateTime.isAfter(now));
      expect(past, isNotEmpty);
      expect(past.every((s) => !s.available), isTrue);
    });

    test('different barbers see different availability patterns', () {
      final a = TimeSlots.forDay(
        shopId: 'kings-cut',
        barberId: 'kings-cut-b1',
        day: day,
        now: beforeOpen,
      );
      final b = TimeSlots.forDay(
        shopId: 'kings-cut',
        barberId: 'kings-cut-b2',
        day: day,
        now: beforeOpen,
      );

      expect(
        a.map((s) => s.available).toList(),
        isNot(b.map((s) => s.available).toList()),
      );
    });
  });
}

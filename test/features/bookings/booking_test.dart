import 'package:flutter_test/flutter_test.dart';
import 'package:trimly/features/bookings/domain/entities/booking.dart';
import 'package:trimly/features/shops/domain/entities/barber.dart';
import 'package:trimly/features/shops/domain/entities/service.dart';

void main() {
  const cut = Service(
    id: 's1',
    name: 'Classic Cut',
    durationMin: 45,
    price: 40,
    category: ServiceCategory.haircut,
  );
  const beard = Service(
    id: 's2',
    name: 'Beard Trim',
    durationMin: 30,
    price: 25,
    category: ServiceCategory.beard,
  );
  const shave = Service(
    id: 's3',
    name: 'Hot Towel Shave',
    durationMin: 40,
    price: 35,
    category: ServiceCategory.shave,
  );

  const barber = Barber(
    id: 'b1',
    name: 'David Chen',
    specialty: 'Fade Specialist',
    rating: 5,
    reviewCount: 124,
  );

  Booking makeBooking(List<Service> services) => Booking(
        id: 'bk1',
        shopId: 'kings-cut',
        shopName: 'Kings Cut Lounge',
        shopImage: 'assets/images/barbershop_interior.png',
        barber: barber,
        services: services,
        dateTime: DateTime(2026, 8, 1, 14, 30),
        status: BookingStatus.confirmed,
      );

  group('booking price logic', () {
    test('total price sums every selected service', () {
      expect(Booking.totalPriceOf([cut, beard, shave]), 100);
    });

    test('total price of a single service is that service price', () {
      expect(Booking.totalPriceOf([beard]), 25);
    });

    test('total price of no services is zero', () {
      expect(Booking.totalPriceOf(const <Service>[]), 0);
    });

    test('booking exposes the derived total', () {
      expect(makeBooking([cut, beard]).totalPrice, 65);
    });

    test('total duration sums service durations', () {
      expect(Booking.totalDurationOf([cut, beard, shave]), 115);
    });
  });

  group('booking serialization', () {
    test('json round-trip preserves every field', () {
      final booking = makeBooking([cut, shave]).copyWith(userRating: 4);
      final restored = Booking.fromJson(booking.toJson());

      expect(restored.id, booking.id);
      expect(restored.shopId, booking.shopId);
      expect(restored.shopName, booking.shopName);
      expect(restored.barber, booking.barber);
      expect(restored.services, booking.services);
      expect(restored.dateTime, booking.dateTime);
      expect(restored.status, booking.status);
      expect(restored.userRating, 4);
      expect(restored.totalPrice, booking.totalPrice);
    });

    test('copyWith changes status without touching identity', () {
      final booking = makeBooking([cut]);
      final cancelled = booking.copyWith(status: BookingStatus.cancelled);

      expect(cancelled.id, booking.id);
      expect(cancelled.status, BookingStatus.cancelled);
      expect(cancelled.services, booking.services);
    });
  });

  group('barber initials', () {
    test('two-word names use first and last initial', () {
      expect(barber.initials, 'DC');
    });

    test('single-word names use the first letter', () {
      const solo = Barber(
        id: 'b2',
        name: 'Cher',
        specialty: 'Styling',
        rating: 4.5,
        reviewCount: 10,
      );
      expect(solo.initials, 'C');
    });
  });
}

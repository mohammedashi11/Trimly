import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/providers/shared_preferences_provider.dart';
import '../../../core/utils/mock_latency.dart';
import '../domain/entities/booking.dart';
import '../domain/repositories/booking_repository.dart';

/// Local mock implementation of [BookingRepository] backed by
/// [SharedPreferences].
class MockBookingRepository implements BookingRepository {
  MockBookingRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _bookingsKey = 'trimly.bookings';

  @override
  Future<List<Booking>> getBookings() async {
    await simulateLatency();
    final bookings = _load().map(_settleStatus).toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
    await _save(bookings);
    return bookings;
  }

  @override
  Future<Booking> createBooking(Booking booking) async {
    await simulateLatency();
    final bookings = _load()..add(booking);
    await _save(bookings);
    return booking;
  }

  @override
  Future<Booking> updateBooking(Booking booking) async {
    await simulateLatency();
    final bookings = _load();
    final index = bookings.indexWhere((b) => b.id == booking.id);
    if (index == -1) throw StateError('Unknown booking: ${booking.id}');
    bookings[index] = booking;
    await _save(bookings);
    return booking;
  }

  @override
  Future<Booking> cancelBooking(String bookingId) async {
    await simulateLatency();
    final bookings = _load();
    final index = bookings.indexWhere((b) => b.id == bookingId);
    if (index == -1) throw StateError('Unknown booking: $bookingId');
    final cancelled = bookings[index].copyWith(
      status: BookingStatus.cancelled,
    );
    bookings[index] = cancelled;
    await _save(bookings);
    return cancelled;
  }

  /// Confirmed appointments whose time has passed become completed.
  Booking _settleStatus(Booking booking) {
    if (booking.status == BookingStatus.confirmed &&
        booking.dateTime.isBefore(DateTime.now())) {
      return booking.copyWith(status: BookingStatus.completed);
    }
    return booking;
  }

  List<Booking> _load() {
    final raw = _prefs.getString(_bookingsKey);
    if (raw == null) return [];
    return (jsonDecode(raw) as List)
        .map((b) => Booking.fromJson(b as Map<String, dynamic>))
        .toList();
  }

  Future<void> _save(List<Booking> bookings) async {
    await _prefs.setString(
      _bookingsKey,
      jsonEncode(bookings.map((b) => b.toJson()).toList()),
    );
  }
}

final bookingRepositoryProvider = Provider<BookingRepository>(
  (ref) => MockBookingRepository(ref.watch(sharedPreferencesProvider)),
);

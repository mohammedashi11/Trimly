import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/mock_booking_repository.dart';
import '../../domain/entities/booking.dart';

/// The user's bookings, newest first.
final bookingsProvider = FutureProvider<List<Booking>>(
  (ref) => ref.watch(bookingRepositoryProvider).getBookings(),
);

/// Mutations on bookings; refreshes [bookingsProvider] after each action.
final bookingActionsProvider =
    AsyncNotifierProvider<BookingActions, void>(BookingActions.new);

class BookingActions extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<Booking?> create(Booking booking) => _run(
        () => ref.read(bookingRepositoryProvider).createBooking(booking),
      );

  Future<Booking?> reschedule(Booking booking) => _run(
        () => ref.read(bookingRepositoryProvider).updateBooking(booking),
      );

  Future<Booking?> cancel(String bookingId) => _run(
        () => ref.read(bookingRepositoryProvider).cancelBooking(bookingId),
      );

  Future<Booking?> rate(Booking booking, int rating) => _run(
        () => ref
            .read(bookingRepositoryProvider)
            .updateBooking(booking.copyWith(userRating: rating)),
      );

  Future<Booking?> _run(Future<Booking> Function() action) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(action);
    state = result.hasError
        ? AsyncError(result.error!, result.stackTrace!)
        : const AsyncData(null);
    ref.invalidate(bookingsProvider);
    return result.valueOrNull;
  }
}

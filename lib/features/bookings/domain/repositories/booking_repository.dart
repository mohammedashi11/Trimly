import '../entities/booking.dart';

/// Persistence for the user's appointments.
abstract interface class BookingRepository {
  /// All bookings, newest appointment first. Confirmed bookings whose time
  /// has passed are surfaced as completed.
  Future<List<Booking>> getBookings();

  Future<Booking> createBooking(Booking booking);

  /// Replaces an existing booking (reschedule, rating).
  Future<Booking> updateBooking(Booking booking);

  Future<Booking> cancelBooking(String bookingId);
}

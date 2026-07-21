import 'package:flutter/material.dart';

/// A bookable half-hour slot on a given day.
@immutable
class TimeSlot {
  const TimeSlot({required this.dateTime, required this.available});

  final DateTime dateTime;
  final bool available;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeSlot &&
          other.dateTime == dateTime &&
          other.available == available;

  @override
  int get hashCode => Object.hash(dateTime, available);
}

/// Pure slot-generation logic for the booking flow.
///
/// Availability is pseudo-random but deterministic per shop, barber and day,
/// so a slot that shows as taken stays taken when the user navigates back.
abstract final class TimeSlots {
  static const int openingHour = 10;
  static const int closingHour = 20;
  static const int slotMinutes = 30;

  /// Generates every slot for [day], marking some unavailable.
  ///
  /// [now] is injectable for tests; slots in the past are never available.
  static List<TimeSlot> forDay({
    required String shopId,
    required String barberId,
    required DateTime day,
    DateTime? now,
  }) {
    final current = now ?? DateTime.now();
    final slots = <TimeSlot>[];
    for (var hour = openingHour; hour < closingHour; hour++) {
      for (var minute = 0; minute < 60; minute += slotMinutes) {
        final dateTime = DateTime(day.year, day.month, day.day, hour, minute);
        final isPast = !dateTime.isAfter(current);
        slots.add(
          TimeSlot(
            dateTime: dateTime,
            available: !isPast && !_isTaken(shopId, barberId, dateTime),
          ),
        );
      }
    }
    return slots;
  }

  /// Deterministic hash deciding whether a slot is already booked.
  ///
  /// Uses FNV-1a over a stable key so results survive app restarts
  /// (unlike [Object.hash], which is seeded per run).
  static bool _isTaken(String shopId, String barberId, DateTime slot) {
    final key = '$shopId|$barberId|${slot.year}-${slot.month}-${slot.day}'
        '|${slot.hour}:${slot.minute}';
    var hash = 0x811c9dc5;
    for (final unit in key.codeUnits) {
      hash = ((hash ^ unit) * 0x01000193) & 0xFFFFFFFF;
    }
    // Roughly a third of slots read as taken, matching the design mock.
    return hash % 3 == 0;
  }
}

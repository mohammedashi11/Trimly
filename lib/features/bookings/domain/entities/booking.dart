import '../../../shops/domain/entities/barber.dart';
import '../../../shops/domain/entities/service.dart';

enum BookingStatus {
  confirmed('Confirmed'),
  completed('Completed'),
  cancelled('Cancelled');

  const BookingStatus(this.label);

  final String label;
}

/// A confirmed appointment at a barbershop.
class Booking {
  const Booking({
    required this.id,
    required this.shopId,
    required this.shopName,
    required this.shopImage,
    required this.barber,
    required this.services,
    required this.dateTime,
    required this.status,
    this.userRating,
  });

  final String id;
  final String shopId;
  final String shopName;
  final String shopImage;
  final Barber barber;
  final List<Service> services;
  final DateTime dateTime;
  final BookingStatus status;

  /// Star rating the user gave after completion (past bookings only).
  final int? userRating;

  /// Total price is always derived from the booked services.
  double get totalPrice => totalPriceOf(services);

  int get totalDurationMin => totalDurationOf(services);

  /// Sums service prices — single source of booking price logic.
  static double totalPriceOf(Iterable<Service> services) =>
      services.fold(0, (sum, s) => sum + s.price);

  static int totalDurationOf(Iterable<Service> services) =>
      services.fold(0, (sum, s) => sum + s.durationMin);

  Booking copyWith({
    Barber? barber,
    List<Service>? services,
    DateTime? dateTime,
    BookingStatus? status,
    int? userRating,
  }) =>
      Booking(
        id: id,
        shopId: shopId,
        shopName: shopName,
        shopImage: shopImage,
        barber: barber ?? this.barber,
        services: services ?? this.services,
        dateTime: dateTime ?? this.dateTime,
        status: status ?? this.status,
        userRating: userRating ?? this.userRating,
      );

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        id: json['id'] as String,
        shopId: json['shopId'] as String,
        shopName: json['shopName'] as String,
        shopImage: json['shopImage'] as String,
        barber: Barber.fromJson(json['barber'] as Map<String, dynamic>),
        services: (json['services'] as List)
            .map((s) => Service.fromJson(s as Map<String, dynamic>))
            .toList(),
        dateTime: DateTime.parse(json['dateTime'] as String),
        status: BookingStatus.values.byName(json['status'] as String),
        userRating: json['userRating'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'shopId': shopId,
        'shopName': shopName,
        'shopImage': shopImage,
        'barber': barber.toJson(),
        'services': services.map((s) => s.toJson()).toList(),
        'dateTime': dateTime.toIso8601String(),
        'status': status.name,
        'userRating': userRating,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Booking && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

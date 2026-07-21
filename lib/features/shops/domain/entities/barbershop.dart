import 'barber.dart';
import 'review.dart';
import 'service.dart';

/// A barbershop with its services, team and social proof.
class Barbershop {
  const Barbershop({
    required this.id,
    required this.name,
    required this.address,
    required this.neighborhood,
    required this.rating,
    required this.reviewCount,
    required this.distanceKm,
    required this.image,
    required this.isOpen,
    required this.services,
    required this.barbers,
    required this.gallery,
    required this.reviews,
  });

  final String id;
  final String name;
  final String address;

  /// Short locality label shown next to the distance (e.g. "Manhattan").
  final String neighborhood;

  final double rating;
  final int reviewCount;
  final double distanceKm;

  /// Primary photo asset for cards and the detail hero.
  final String image;

  final bool isOpen;
  final List<Service> services;
  final List<Barber> barbers;
  final List<String> gallery;
  final List<Review> reviews;

  /// Categories covered by this shop's service menu.
  Set<ServiceCategory> get categories =>
      services.map((s) => s.category).toSet();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Barbershop && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

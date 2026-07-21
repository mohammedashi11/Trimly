/// A barber working at a shop.
class Barber {
  const Barber({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.reviewCount,
  });

  final String id;
  final String name;
  final String specialty;
  final double rating;
  final int reviewCount;

  /// Initials used for the avatar monogram (e.g. "David Chen" → "DC").
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  factory Barber.fromJson(Map<String, dynamic> json) => Barber(
        id: json['id'] as String,
        name: json['name'] as String,
        specialty: json['specialty'] as String,
        rating: (json['rating'] as num).toDouble(),
        reviewCount: json['reviewCount'] as int,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'specialty': specialty,
        'rating': rating,
        'reviewCount': reviewCount,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Barber && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

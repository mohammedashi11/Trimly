/// A customer review left on a barbershop.
class Review {
  const Review({
    required this.id,
    required this.author,
    required this.rating,
    required this.text,
    required this.date,
  });

  final String id;
  final String author;
  final double rating;
  final String text;
  final DateTime date;

  String get authorInitials {
    final parts = author.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}

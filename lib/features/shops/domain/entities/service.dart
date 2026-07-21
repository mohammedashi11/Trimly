/// High-level grouping used by the home screen category filter.
enum ServiceCategory {
  haircut('Haircut'),
  beard('Beard'),
  shave('Shave'),
  coloring('Coloring'),
  grooming('Grooming');

  const ServiceCategory(this.label);

  final String label;
}

/// A bookable service offered by a barbershop.
class Service {
  const Service({
    required this.id,
    required this.name,
    required this.durationMin,
    required this.price,
    required this.category,
  });

  final String id;
  final String name;
  final int durationMin;
  final double price;
  final ServiceCategory category;

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json['id'] as String,
        name: json['name'] as String,
        durationMin: json['durationMin'] as int,
        price: (json['price'] as num).toDouble(),
        category: ServiceCategory.values.byName(json['category'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'durationMin': durationMin,
        'price': price,
        'category': category.name,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Service && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

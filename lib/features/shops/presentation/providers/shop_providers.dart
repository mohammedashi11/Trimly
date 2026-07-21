import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/mock_shop_repository.dart';
import '../../domain/entities/barber.dart';
import '../../domain/entities/barbershop.dart';
import '../../domain/entities/service.dart';

/// The full shop catalogue.
final shopsProvider = FutureProvider<List<Barbershop>>(
  (ref) => ref.watch(shopRepositoryProvider).getShops(),
);

/// A single shop by id (used by detail and booking screens).
final shopProvider = FutureProvider.family<Barbershop, String>(
  (ref, id) => ref.watch(shopRepositoryProvider).getShopById(id),
);

/// Live search query typed into the home search bar.
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Currently selected category chip, or null for all.
final selectedCategoryProvider =
    StateProvider<ServiceCategory?>((ref) => null);

/// Shops filtered by search query and category chip.
final filteredShopsProvider = Provider<AsyncValue<List<Barbershop>>>((ref) {
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  final category = ref.watch(selectedCategoryProvider);

  return ref.watch(shopsProvider).whenData((shops) {
    return shops.where((shop) {
      final matchesCategory =
          category == null || shop.categories.contains(category);
      if (!matchesCategory) return false;
      if (query.isEmpty) return true;
      return shop.name.toLowerCase().contains(query) ||
          shop.neighborhood.toLowerCase().contains(query) ||
          shop.barbers.any((b) => b.name.toLowerCase().contains(query)) ||
          shop.services.any((s) => s.name.toLowerCase().contains(query));
    }).toList();
  });
});

/// Shops ranked by rating for the "Top Rated Near You" rail.
final topRatedShopsProvider = Provider<AsyncValue<List<Barbershop>>>((ref) {
  return ref.watch(filteredShopsProvider).whenData(
        (shops) => [...shops]..sort((a, b) => b.rating.compareTo(a.rating)),
      );
});

/// A barber together with the shop they work at.
typedef BarberAtShop = ({Barber barber, Barbershop shop});

/// Highest-rated barbers across every (filtered) shop.
final popularBarbersProvider = Provider<AsyncValue<List<BarberAtShop>>>((ref) {
  return ref.watch(filteredShopsProvider).whenData((shops) {
    final all = [
      for (final shop in shops)
        for (final barber in shop.barbers) (barber: barber, shop: shop),
    ]..sort((a, b) => b.barber.rating.compareTo(a.barber.rating));
    return all;
  });
});

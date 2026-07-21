import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/providers/shared_preferences_provider.dart';
import '../../../core/utils/mock_latency.dart';
import '../domain/entities/barbershop.dart';
import '../domain/repositories/shop_repository.dart';
import 'shop_seed_data.dart';

/// Local mock implementation of [ShopRepository].
///
/// Serves the deterministic seed catalogue with simulated network latency;
/// favorites persist across sessions via [SharedPreferences].
class MockShopRepository implements ShopRepository {
  MockShopRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _favoritesKey = 'trimly.favorite_shop_ids';

  @override
  Future<List<Barbershop>> getShops() async {
    await simulateLatency();
    return ShopSeedData.shops;
  }

  @override
  Future<Barbershop> getShopById(String id) async {
    await simulateLatency();
    return ShopSeedData.shops.firstWhere(
      (shop) => shop.id == id,
      orElse: () => throw StateError('Unknown barbershop: $id'),
    );
  }

  @override
  Future<Set<String>> getFavoriteShopIds() async {
    return (_prefs.getStringList(_favoritesKey) ?? const []).toSet();
  }

  @override
  Future<Set<String>> toggleFavorite(String shopId) async {
    final favorites = await getFavoriteShopIds();
    if (!favorites.remove(shopId)) favorites.add(shopId);
    await _prefs.setStringList(_favoritesKey, favorites.toList());
    return favorites;
  }
}

final shopRepositoryProvider = Provider<ShopRepository>(
  (ref) => MockShopRepository(ref.watch(sharedPreferencesProvider)),
);

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shops/data/mock_shop_repository.dart';
import '../../../shops/domain/entities/barbershop.dart';
import '../../../shops/presentation/providers/shop_providers.dart';

/// Persisted set of favorite shop ids with optimistic toggling.
final favoritesControllerProvider =
    AsyncNotifierProvider<FavoritesController, Set<String>>(
  FavoritesController.new,
);

class FavoritesController extends AsyncNotifier<Set<String>> {
  @override
  Future<Set<String>> build() =>
      ref.watch(shopRepositoryProvider).getFavoriteShopIds();

  Future<void> toggle(String shopId) async {
    // Optimistic flip so the heart responds instantly.
    final current = {...state.valueOrNull ?? <String>{}};
    if (!current.remove(shopId)) current.add(shopId);
    state = AsyncData(current);

    state = AsyncData(
      await ref.read(shopRepositoryProvider).toggleFavorite(shopId),
    );
  }
}

/// The favorited shops, in catalogue order.
final favoriteShopsProvider = Provider<AsyncValue<List<Barbershop>>>((ref) {
  final favorites = ref.watch(favoritesControllerProvider).valueOrNull ?? {};
  return ref.watch(shopsProvider).whenData(
        (shops) => shops.where((s) => favorites.contains(s.id)).toList(),
      );
});

import '../entities/barbershop.dart';

/// Read access to barbershops plus favorite management.
///
/// Implementations may be backed by mock data today and a remote API
/// tomorrow — presentation code must only depend on this interface.
abstract interface class ShopRepository {
  Future<List<Barbershop>> getShops();

  Future<Barbershop> getShopById(String id);

  Future<Set<String>> getFavoriteShopIds();

  /// Toggles [shopId] in the favorites set and returns the new set.
  Future<Set<String>> toggleFavorite(String shopId);
}

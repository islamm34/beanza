import '../entities/favorites_entity.dart';

abstract class FavoritesRepository {
  Future<List<FavoriteCafeEntity>> getFavoriteCafes();
  Future<List<FavoriteProductEntity>> getFavoriteProducts();
  Future<void> addCafeToFavorites(String cafeId);
  Future<void> removeCafeFromFavorites(String cafeId);
  Future<void> addProductToFavorites(String productId);
  Future<void> removeProductFromFavorites(String productId);
}

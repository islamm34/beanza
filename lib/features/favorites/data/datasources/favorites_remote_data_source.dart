abstract class FavoritesRemoteDataSource {
  /// Gets favorite cafes
  Future<List<Map<String, dynamic>>> getFavoriteCafes();

  /// Gets favorite products
  Future<List<Map<String, dynamic>>> getFavoriteProducts();

  /// Adds cafe to favorites
  Future<void> addCafeToFavorites(String cafeId);

  /// Removes cafe from favorites
  Future<void> removeCafeFromFavorites(String cafeId);

  /// Adds product to favorites
  Future<void> addProductToFavorites(String productId);

  /// Removes product from favorites
  Future<void> removeProductFromFavorites(String productId);
}

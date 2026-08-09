abstract class HomeRemoteDataSource {
  /// Gets hero banner data
  Future<Map<String, dynamic>> getHeroBanner();

  /// Gets product categories
  Future<List<Map<String, dynamic>>> getCategories();

  /// Gets featured products
  Future<List<Map<String, dynamic>>> getFeaturedProducts();

  /// Gets promotions
  Future<List<Map<String, dynamic>>> getPromotions();
}

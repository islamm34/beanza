abstract class ProductsRemoteDataSource {
  /// Gets product details with variants
  Future<Map<String, dynamic>> getProductDetails(String productId);

  /// Gets related products
  Future<List<Map<String, dynamic>>> getRelatedProducts(String productId);

  /// Gets product reviews
  Future<List<Map<String, dynamic>>> getProductReviews(String productId);
}

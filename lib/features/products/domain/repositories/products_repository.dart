import '../entities/products_entity.dart';

abstract class ProductsRepository {
  Future<ProductEntity> getProductDetails(String productId);
  Future<List<ProductEntity>> getRelatedProducts(String productId);
  Future<List<ProductReviewEntity>> getProductReviews(String productId);
}

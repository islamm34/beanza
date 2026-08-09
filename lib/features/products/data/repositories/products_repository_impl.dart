import '../../domain/entities/products_entity.dart';
import '../../domain/repositories/products_repository.dart';
import '../datasources/products_remote_data_source.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource remoteDataSource;

  ProductsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ProductEntity> getProductDetails(String productId) async {
    try {
      final data = await remoteDataSource.getProductDetails(productId);
      return ProductEntity(
        id: data['id'] as String? ?? '',
        name: data['name'] as String? ?? '',
        description: data['description'] as String? ?? '',
        basePrice: (data['basePrice'] as num?)?.toDouble() ?? 0.0,
        imageUrl: data['imageUrl'] as String? ?? '',
        rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
        reviewCount: data['reviewCount'] as int? ?? 0,
        variants: (data['variants'] as List<dynamic>? ?? [])
            .map(
              (v) => ProductVariantEntity(
                id: v['id'] as String? ?? '',
                name: v['name'] as String? ?? '',
                price: (v['price'] as num?)?.toDouble() ?? 0.0,
                size: v['size'] as String? ?? '',
                customizations: List<String>.from(
                  v['customizations'] as List<dynamic>? ?? [],
                ),
              ),
            )
            .toList(),
        category: data['category'] as String? ?? '',
        isAvailable: data['isAvailable'] as bool? ?? true,
      );
    } catch (e) {
      throw Exception('Failed to get product details: $e');
    }
  }

  @override
  Future<List<ProductEntity>> getRelatedProducts(String productId) async {
    try {
      final products = await remoteDataSource.getRelatedProducts(productId);
      return products
          .map(
            (p) => ProductEntity(
              id: p['id'] as String? ?? '',
              name: p['name'] as String? ?? '',
              description: p['description'] as String? ?? '',
              basePrice: (p['basePrice'] as num?)?.toDouble() ?? 0.0,
              imageUrl: p['imageUrl'] as String? ?? '',
              rating: (p['rating'] as num?)?.toDouble() ?? 0.0,
              reviewCount: p['reviewCount'] as int? ?? 0,
              variants: [],
              category: p['category'] as String? ?? '',
              isAvailable: p['isAvailable'] as bool? ?? true,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get related products: $e');
    }
  }

  @override
  Future<List<ProductReviewEntity>> getProductReviews(String productId) async {
    try {
      final reviews = await remoteDataSource.getProductReviews(productId);
      return reviews
          .map(
            (r) => ProductReviewEntity(
              id: r['id'] as String? ?? '',
              userName: r['userName'] as String? ?? '',
              rating: (r['rating'] as num?)?.toDouble() ?? 0.0,
              comment: r['comment'] as String? ?? '',
              createdAt: r['createdAt'] as String? ?? '',
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get product reviews: $e');
    }
  }
}

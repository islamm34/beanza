import '../../domain/entities/home_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<HeroBannerEntity> getHeroBanner() async {
    try {
      final data = await remoteDataSource.getHeroBanner();
      return HeroBannerEntity(
        id: data['id'] as String? ?? '',
        title: data['title'] as String? ?? '',
        subtitle: data['subtitle'] as String? ?? '',
        imageUrl: data['imageUrl'] as String? ?? '',
        actionLabel: data['actionLabel'] as String? ?? '',
      );
    } catch (e) {
      throw Exception('Failed to get hero banner: $e');
    }
  }

  @override
  Future<List<CategoryEntity>> getCategories() async {
    try {
      final data = await remoteDataSource.getCategories();
      return data
          .map(
            (item) => CategoryEntity(
              id: item['id'] as String? ?? '',
              name: item['name'] as String? ?? '',
              icon: item['icon'] as String? ?? '',
              color: item['color'] as String? ?? '#000000',
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get categories: $e');
    }
  }

  @override
  Future<List<ProductEntity>> getFeaturedProducts() async {
    try {
      final data = await remoteDataSource.getFeaturedProducts();
      return data
          .map(
            (item) => ProductEntity(
              id: item['id'] as String? ?? '',
              name: item['name'] as String? ?? '',
              description: item['description'] as String? ?? '',
              basePrice:
                  (item['basePrice'] as num?)?.toDouble() ??
                  (item['price'] as num?)?.toDouble() ??
                  0.0,
              imageUrl: item['imageUrl'] as String? ?? '',
              rating: (item['rating'] as num?)?.toDouble() ?? 0.0,
              reviewCount: item['reviewCount'] as int? ?? 0,
              variants: const [],
              category: item['category'] as String? ?? '',
              isAvailable: item['isAvailable'] as bool? ?? true,
              price: (item['price'] as num?)?.toDouble() ?? 0.0,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get featured products: $e');
    }
  }
}

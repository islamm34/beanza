import '../../domain/entities/explore_entity.dart';
import '../../domain/repositories/explore_repository.dart';
import '../datasources/explore_remote_data_source.dart';

class ExploreRepositoryImpl implements ExploreRepository {
  final ExploreRemoteDataSource remoteDataSource;

  ExploreRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CafeEntity>> getCafes({
    String? searchQuery,
    String? categoryFilter,
    double? maxDistance,
  }) async {
    try {
      final cafes = await remoteDataSource.getCafes(
        searchQuery: searchQuery,
        categoryFilter: categoryFilter,
        maxDistance: maxDistance,
      );
      return cafes
          .map(
            (cafe) => CafeEntity(
              id: cafe['id'] as String? ?? '',
              name: cafe['name'] as String? ?? '',
              address: cafe['address'] as String? ?? '',
              latitude: (cafe['latitude'] as num?)?.toDouble() ?? 0.0,
              longitude: (cafe['longitude'] as num?)?.toDouble() ?? 0.0,
              rating: (cafe['rating'] as num?)?.toDouble() ?? 0.0,
              reviewCount: cafe['reviewCount'] as int? ?? 0,
              imageUrl: cafe['imageUrl'] as String? ?? '',
              tags: List<String>.from(cafe['tags'] as List<dynamic>? ?? []),
              distance: (cafe['distance'] as num?)?.toDouble() ?? 0.0,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get cafes: $e');
    }
  }

  @override
  Future<CafeEntity> getCafeDetails(String cafeId) async {
    try {
      final cafe = await remoteDataSource.getCafeDetails(cafeId);
      return CafeEntity(
        id: cafe['id'] as String? ?? '',
        name: cafe['name'] as String? ?? '',
        address: cafe['address'] as String? ?? '',
        latitude: (cafe['latitude'] as num?)?.toDouble() ?? 0.0,
        longitude: (cafe['longitude'] as num?)?.toDouble() ?? 0.0,
        rating: (cafe['rating'] as num?)?.toDouble() ?? 0.0,
        reviewCount: cafe['reviewCount'] as int? ?? 0,
        imageUrl: cafe['imageUrl'] as String? ?? '',
        tags: List<String>.from(cafe['tags'] as List<dynamic>? ?? []),
        distance: (cafe['distance'] as num?)?.toDouble() ?? 0.0,
      );
    } catch (e) {
      throw Exception('Failed to get cafe details: $e');
    }
  }

  @override
  Future<List<CafeReviewEntity>> getCafeReviews(String cafeId) async {
    try {
      final reviews = await remoteDataSource.getCafeReviews(cafeId);
      return reviews
          .map(
            (review) => CafeReviewEntity(
              id: review['id'] as String? ?? '',
              userName: review['userName'] as String? ?? '',
              userImage: review['userImage'] as String? ?? '',
              rating: (review['rating'] as num?)?.toDouble() ?? 0.0,
              comment: review['comment'] as String? ?? '',
              createdAt: review['createdAt'] as String? ?? '',
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get cafe reviews: $e');
    }
  }
}

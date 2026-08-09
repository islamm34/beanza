import '../entities/explore_entity.dart';

abstract class ExploreRepository {
  Future<List<CafeEntity>> getCafes({
    String? searchQuery,
    String? categoryFilter,
    double? maxDistance,
  });

  Future<CafeEntity> getCafeDetails(String cafeId);

  Future<List<CafeReviewEntity>> getCafeReviews(String cafeId);
}

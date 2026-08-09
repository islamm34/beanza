import '../entities/explore_entity.dart';
import '../repositories/explore_repository.dart';

class GetCafesUsecase {
  final ExploreRepository repository;

  GetCafesUsecase({required this.repository});

  Future<List<CafeEntity>> call({
    String? searchQuery,
    String? categoryFilter,
    double? maxDistance,
  }) async {
    return await repository.getCafes(
      searchQuery: searchQuery,
      categoryFilter: categoryFilter,
      maxDistance: maxDistance,
    );
  }
}

class GetCafeDetailsUsecase {
  final ExploreRepository repository;

  GetCafeDetailsUsecase({required this.repository});

  Future<CafeEntity> call(String cafeId) async {
    return await repository.getCafeDetails(cafeId);
  }
}

class GetCafeReviewsUsecase {
  final ExploreRepository repository;

  GetCafeReviewsUsecase({required this.repository});

  Future<List<CafeReviewEntity>> call(String cafeId) async {
    return await repository.getCafeReviews(cafeId);
  }
}

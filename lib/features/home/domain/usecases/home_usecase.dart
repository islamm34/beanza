import '../entities/home_entity.dart';
import '../repositories/home_repository.dart';

class GetHeroBannerUsecase {
  final HomeRepository repository;

  GetHeroBannerUsecase({required this.repository});

  Future<HeroBannerEntity> call() async {
    return await repository.getHeroBanner();
  }
}

class GetCategoriesUsecase {
  final HomeRepository repository;

  GetCategoriesUsecase({required this.repository});

  Future<List<CategoryEntity>> call() async {
    return await repository.getCategories();
  }
}

class GetFeaturedProductsUsecase {
  final HomeRepository repository;

  GetFeaturedProductsUsecase({required this.repository});

  Future<List<ProductEntity>> call() async {
    return await repository.getFeaturedProducts();
  }
}

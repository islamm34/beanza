import '../entities/home_entity.dart';

abstract class HomeRepository {
  Future<HeroBannerEntity> getHeroBanner();
  Future<List<CategoryEntity>> getCategories();
  Future<List<ProductEntity>> getFeaturedProducts();
}

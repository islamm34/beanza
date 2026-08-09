import '../entities/products_entity.dart';
import '../repositories/products_repository.dart';

class GetProductDetailsUsecase {
  final ProductsRepository repository;

  GetProductDetailsUsecase({required this.repository});

  Future<ProductEntity> call(String productId) async {
    return await repository.getProductDetails(productId);
  }
}

class GetRelatedProductsUsecase {
  final ProductsRepository repository;

  GetRelatedProductsUsecase({required this.repository});

  Future<List<ProductEntity>> call(String productId) async {
    return await repository.getRelatedProducts(productId);
  }
}

class GetProductReviewsUsecase {
  final ProductsRepository repository;

  GetProductReviewsUsecase({required this.repository});

  Future<List<ProductReviewEntity>> call(String productId) async {
    return await repository.getProductReviews(productId);
  }
}

import '../entities/favorites_entity.dart';
import '../repositories/favorites_repository.dart';

class GetFavoriteCafesUsecase {
  final FavoritesRepository repository;

  GetFavoriteCafesUsecase({required this.repository});

  Future<List<FavoriteCafeEntity>> call() async {
    return await repository.getFavoriteCafes();
  }
}

class GetFavoriteProductsUsecase {
  final FavoritesRepository repository;

  GetFavoriteProductsUsecase({required this.repository});

  Future<List<FavoriteProductEntity>> call() async {
    return await repository.getFavoriteProducts();
  }
}

class AddCafeToFavoritesUsecase {
  final FavoritesRepository repository;

  AddCafeToFavoritesUsecase({required this.repository});

  Future<void> call(String cafeId) async {
    return await repository.addCafeToFavorites(cafeId);
  }
}

class RemoveCafeFromFavoritesUsecase {
  final FavoritesRepository repository;

  RemoveCafeFromFavoritesUsecase({required this.repository});

  Future<void> call(String cafeId) async {
    return await repository.removeCafeFromFavorites(cafeId);
  }
}

class AddProductToFavoritesUsecase {
  final FavoritesRepository repository;

  AddProductToFavoritesUsecase({required this.repository});

  Future<void> call(String productId) async {
    return await repository.addProductToFavorites(productId);
  }
}

class RemoveProductFromFavoritesUsecase {
  final FavoritesRepository repository;

  RemoveProductFromFavoritesUsecase({required this.repository});

  Future<void> call(String productId) async {
    return await repository.removeProductFromFavorites(productId);
  }
}

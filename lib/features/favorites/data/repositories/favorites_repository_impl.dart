import '../../domain/entities/favorites_entity.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_remote_data_source.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesRemoteDataSource remoteDataSource;

  FavoritesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<FavoriteCafeEntity>> getFavoriteCafes() async {
    try {
      final cafes = await remoteDataSource.getFavoriteCafes();
      return cafes
          .map(
            (cafe) => FavoriteCafeEntity(
              id: cafe['id'] as String? ?? '',
              name: cafe['name'] as String? ?? '',
              imageUrl: cafe['imageUrl'] as String? ?? '',
              rating: (cafe['rating'] as num?)?.toDouble() ?? 0.0,
              address: cafe['address'] as String? ?? '',
              distance: (cafe['distance'] as num?)?.toDouble() ?? 0.0,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get favorite cafes: $e');
    }
  }

  @override
  Future<List<FavoriteProductEntity>> getFavoriteProducts() async {
    try {
      final products = await remoteDataSource.getFavoriteProducts();
      return products
          .map(
            (product) => FavoriteProductEntity(
              id: product['id'] as String? ?? '',
              name: product['name'] as String? ?? '',
              price: (product['price'] as num?)?.toDouble() ?? 0.0,
              imageUrl: product['imageUrl'] as String? ?? '',
              cafeId: product['cafeId'] as String? ?? '',
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get favorite products: $e');
    }
  }

  @override
  Future<void> addCafeToFavorites(String cafeId) async {
    try {
      await remoteDataSource.addCafeToFavorites(cafeId);
    } catch (e) {
      throw Exception('Failed to add cafe to favorites: $e');
    }
  }

  @override
  Future<void> removeCafeFromFavorites(String cafeId) async {
    try {
      await remoteDataSource.removeCafeFromFavorites(cafeId);
    } catch (e) {
      throw Exception('Failed to remove cafe from favorites: $e');
    }
  }

  @override
  Future<void> addProductToFavorites(String productId) async {
    try {
      await remoteDataSource.addProductToFavorites(productId);
    } catch (e) {
      throw Exception('Failed to add product to favorites: $e');
    }
  }

  @override
  Future<void> removeProductFromFavorites(String productId) async {
    try {
      await remoteDataSource.removeProductFromFavorites(productId);
    } catch (e) {
      throw Exception('Failed to remove product from favorites: $e');
    }
  }
}

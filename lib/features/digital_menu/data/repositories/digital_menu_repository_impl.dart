import '../../domain/entities/digital_menu_entity.dart';
import '../../domain/repositories/digital_menu_repository.dart'
    show DigitalMenuRepository;
import '../datasources/digital_menu_remote_data_source.dart';

class DigitalMenuRepositoryImpl implements DigitalMenuRepository {
  final DigitalMenuRemoteDataSource remoteDataSource;

  DigitalMenuRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Map<String, dynamic>> getDigitalMenu(String cafeId) async {
    try {
      return await remoteDataSource.getDigitalMenu(cafeId);
    } catch (e) {
      throw Exception('Failed to get digital menu: $e');
    }
  }

  @override
  Future<List<MenuCategoryEntity>> getMenuCategories(String cafeId) async {
    try {
      final categories = await remoteDataSource.getMenuCategories(cafeId);
      return categories
          .map(
            (cat) => MenuCategoryEntity(
              id: cat['id'] as String? ?? '',
              name: cat['name'] as String? ?? '',
              icon: cat['icon'] as String? ?? '',
              itemCount: cat['itemCount'] as int? ?? 0,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get menu categories: $e');
    }
  }

  @override
  Future<List<MenuItemEntity>> searchMenuItems(
    String cafeId,
    String query,
  ) async {
    try {
      final items = await remoteDataSource.searchMenuItems(cafeId, query);
      return items
          .map(
            (item) => MenuItemEntity(
              id: item['id'] as String? ?? '',
              name: item['name'] as String? ?? '',
              description: item['description'] as String? ?? '',
              price: (item['price'] as num?)?.toDouble() ?? 0.0,
              imageUrl: item['imageUrl'] as String? ?? '',
              categoryId: item['categoryId'] as String? ?? '',
              isAvailable: item['isAvailable'] as bool? ?? true,
              addons: List<String>.from(item['addons'] as List<dynamic>? ?? []),
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to search menu items: $e');
    }
  }
}

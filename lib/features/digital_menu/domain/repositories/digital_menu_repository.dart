import '../entities/digital_menu_entity.dart';

abstract class DigitalMenuRepository {
  Future<Map<String, dynamic>> getDigitalMenu(String cafeId);
  Future<List<MenuCategoryEntity>> getMenuCategories(String cafeId);
  Future<List<MenuItemEntity>> searchMenuItems(String cafeId, String query);
}

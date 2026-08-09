import '../entities/digital_menu_entity.dart';
import '../repositories/digital_menu_repository.dart';

class GetMenuCategoriesUsecase {
  final DigitalMenuRepository repository;

  GetMenuCategoriesUsecase({required this.repository});

  Future<List<MenuCategoryEntity>> call(String cafeId) async {
    return await repository.getMenuCategories(cafeId);
  }
}

class SearchMenuItemsUsecase {
  final DigitalMenuRepository repository;

  SearchMenuItemsUsecase({required this.repository});

  Future<List<MenuItemEntity>> call(String cafeId, String query) async {
    return await repository.searchMenuItems(cafeId, query);
  }
}

import 'package:get/get.dart';
import '../../core/data/local_product_catalog.dart';
import '../../core/models/product_model.dart';

class ProductsController extends GetxController {
  final selectedCategory = 'All'.obs;
  final searchQuery = ''.obs;

  List<String> get categories => LocalProductCatalog.categories;
  List<Product> get allProducts => LocalProductCatalog.products;

  List<Product> get popularProducts =>
      allProducts.where((p) => p.isPopular).toList();

  List<Product> get newProducts => allProducts.where((p) => p.isNew).toList();

  List<Product> get filteredProducts {
    return allProducts.where((product) {
      final cat = selectedCategory.value.trim().toLowerCase();
      final matchesCategory = cat == 'all' ||
          product.category.toLowerCase() == cat ||
          (cat == 'espresso' &&
              product.name.toLowerCase().contains('espresso')) ||
          (cat == 'latte' && product.name.toLowerCase().contains('latte')) ||
          (cat == 'cappuccino' &&
              product.name.toLowerCase().contains('cappuccino')) ||
          (cat == 'americano' &&
              product.name.toLowerCase().contains('americano')) ||
          (cat == 'cold coffee' &&
              (product.category.toLowerCase().contains('iced') ||
                  product.name.toLowerCase().contains('iced') ||
                  product.name.toLowerCase().contains('cold')));

      final query = searchQuery.value.trim().toLowerCase();
      final matchesQuery = query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query) ||
          product.ingredients.any((ing) => ing.toLowerCase().contains(query));

      return matchesCategory && matchesQuery;
    }).toList();
  }

  void setCategory(String category) {
    selectedCategory.value = category;
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void resetFilters() {
    selectedCategory.value = 'All';
    searchQuery.value = '';
  }

  String getLocalizedCategoryName(String category) {
    return LocalProductCatalog.getCategoryDisplayName(category);
  }
}

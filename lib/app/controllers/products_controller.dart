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
      final matchesCategory = selectedCategory.value == 'All' ||
          product.category == selectedCategory.value;

      final query = searchQuery.value.toLowerCase().trim();
      final matchesQuery = query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query);

      return matchesCategory && matchesQuery;
    }).toList();
  }

  void setCategory(String category) {
    selectedCategory.value = category;
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }
}

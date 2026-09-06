import 'package:get/get.dart';
import '../../core/data/local_product_catalog.dart';
import '../../core/models/product_model.dart';

enum ExploreSortOption {
  recommended('Recommended'),
  mostPopular('Most Popular'),
  highestRated('Highest Rated'),
  priceLowToHigh('Price: Low to High'),
  priceHighToLow('Price: High to Low'),
  nameAToZ('Name: A to Z');

  final String label;
  const ExploreSortOption(this.label);
}

class ExploreController extends GetxController {
  final selectedCategory = 'All'.obs;
  final searchQuery = ''.obs;
  final selectedSort = ExploreSortOption.recommended.obs;

  // Advanced Filters
  final maxPrice = 20.0.obs;
  final minRating = 0.0.obs;
  final onlyHot = false.obs;
  final onlyIced = false.obs;

  // State flags
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  List<String> get categories => LocalProductCatalog.categories;

  int get activeFilterCount {
    int count = 0;
    if (minRating.value > 0.0) count++;
    if (maxPrice.value < 20.0) count++;
    if (onlyHot.value) count++;
    if (onlyIced.value) count++;
    return count;
  }

  List<Product> get filteredProducts {
    List<Product> list = List.from(LocalProductCatalog.products);

    // 1. Category Filter
    final cat = selectedCategory.value.trim().toLowerCase();
    if (cat != 'all') {
      list = list.where((product) {
        final prodCat = product.category.toLowerCase();
        final name = product.name.toLowerCase();

        return prodCat == cat ||
            (cat == 'hot coffee' && prodCat == 'hot coffee') ||
            (cat == 'iced coffee' &&
                (prodCat == 'iced coffee' ||
                    name.contains('iced') ||
                    name.contains('cold'))) ||
            (cat == 'specialty' && prodCat == 'specialty') ||
            (cat == 'non-coffee' && prodCat == 'non-coffee') ||
            (cat == 'espresso' && name.contains('espresso')) ||
            (cat == 'latte' && name.contains('latte')) ||
            (cat == 'cappuccino' && name.contains('cappuccino')) ||
            (cat == 'americano' && name.contains('americano'));
      }).toList();
    }

    // 2. Search Query Filter
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isNotEmpty) {
      list = list.where((product) {
        return product.name.toLowerCase().contains(query) ||
            product.description.toLowerCase().contains(query) ||
            product.category.toLowerCase().contains(query) ||
            product.ingredients.any((ing) => ing.toLowerCase().contains(query));
      }).toList();
    }

    // 3. Advanced Filters
    if (minRating.value > 0.0) {
      list = list.where((p) => p.rating >= minRating.value).toList();
    }

    if (maxPrice.value < 20.0) {
      list = list.where((p) => p.basePrice <= maxPrice.value).toList();
    }

    if (onlyHot.value) {
      list = list.where((p) {
        final name = p.name.toLowerCase();
        final c = p.category.toLowerCase();
        return !name.contains('iced') &&
            !name.contains('cold') &&
            c != 'iced coffee';
      }).toList();
    }

    if (onlyIced.value) {
      list = list.where((p) {
        final name = p.name.toLowerCase();
        final c = p.category.toLowerCase();
        return name.contains('iced') ||
            name.contains('cold') ||
            c == 'iced coffee';
      }).toList();
    }

    // 4. Sorting
    switch (selectedSort.value) {
      case ExploreSortOption.mostPopular:
        list.sort((a, b) {
          if (a.isPopular && !b.isPopular) return -1;
          if (!a.isPopular && b.isPopular) return 1;
          return b.reviewsCount.compareTo(a.reviewsCount);
        });
        break;
      case ExploreSortOption.highestRated:
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case ExploreSortOption.priceLowToHigh:
        list.sort((a, b) => a.basePrice.compareTo(b.basePrice));
        break;
      case ExploreSortOption.priceHighToLow:
        list.sort((a, b) => b.basePrice.compareTo(a.basePrice));
        break;
      case ExploreSortOption.nameAToZ:
        list.sort((a, b) => a.name.compareTo(b.name));
        break;
      case ExploreSortOption.recommended:
      default:
        break;
    }

    return list;
  }

  void setCategory(String category) {
    selectedCategory.value = category;
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void setSort(ExploreSortOption sort) {
    selectedSort.value = sort;
  }

  void applyAdvancedFilters({
    required double maxPriceVal,
    required double minRatingVal,
    required bool hotVal,
    required bool icedVal,
  }) {
    maxPrice.value = maxPriceVal;
    minRating.value = minRatingVal;
    onlyHot.value = hotVal;
    onlyIced.value = icedVal;
  }

  void clearAdvancedFilters() {
    maxPrice.value = 20.0;
    minRating.value = 0.0;
    onlyHot.value = false;
    onlyIced.value = false;
  }

  void resetAll() {
    selectedCategory.value = 'All';
    searchQuery.value = '';
    selectedSort.value = ExploreSortOption.recommended;
    clearAdvancedFilters();
    hasError.value = false;
  }

  Future<void> refreshMenu() async {
    isLoading.value = true;
    hasError.value = false;
    await Future.delayed(const Duration(milliseconds: 600));
    isLoading.value = false;
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/controllers/explore_controller.dart';
import '../../../../app/controllers/favorites_controller.dart';
import '../../../../app/controllers/product_details_controller.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/cards/cafe_card.dart';
import '../../../../core/widgets/cards/product_card.dart';
import '../../../../core/widgets/common/app_app_bar.dart';
import '../../../../core/widgets/common/empty_state.dart';
import '../../../../core/widgets/inputs/search_field.dart';
import '../../../../core/widgets/table/table_session_banner.dart';
import '../../../products/presentation/pages/products_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late final ExploreController exploreController;
  late final FavoritesController favoritesController;

  @override
  void initState() {
    super.initState();
    exploreController = Get.put(ExploreController());
    favoritesController = Get.find<FavoritesController>();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const AppAppBar(
        title: 'Explore Cafes & Menu',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TableSessionBanner(),

            // Search Bar with Filter Button
            SearchField(
              hintText: 'Search coffee, drinks, category...',
              onChanged: (val) => exploreController.setSearchQuery(val),
              onClear: () => exploreController.setSearchQuery(''),
              onFilterPressed: () => _showFilterBottomSheet(context),
            ),
            const SizedBox(height: 12),

            // Category Chips Row
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: exploreController.categories.length,
                itemBuilder: (context, index) {
                  final cat = exploreController.categories[index];
                  return Obx(() {
                    final isSelected =
                        exploreController.selectedCategory.value == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(cat),
                        selected: isSelected,
                        selectedColor: AppColors.caramel,
                        backgroundColor: isDark
                            ? AppColors.darkCardBg
                            : AppColors.lightSecondaryBg,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? AppColors.espressoDark
                              : AppColors.getTextColor(
                                  Theme.of(context).brightness),
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 13,
                        ),
                        onSelected: (_) => exploreController.setCategory(cat),
                      ),
                    );
                  });
                },
              ),
            ),
            const SizedBox(height: 12),

            // Sorting & Filter Badge Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Sort Dropdown Selector
                Obx(
                  () => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkCardBg
                          : AppColors.lightSecondaryBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.12)
                            : Colors.black.withValues(alpha: 0.08),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<ExploreSortOption>(
                        value: exploreController.selectedSort.value,
                        isDense: true,
                        icon: const Icon(Icons.swap_vert_rounded,
                            size: 18, color: AppColors.caramel),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.getTextColor(
                              Theme.of(context).brightness),
                        ),
                        onChanged: (newSort) {
                          if (newSort != null)
                            exploreController.setSort(newSort);
                        },
                        items: ExploreSortOption.values.map((sort) {
                          return DropdownMenuItem(
                            value: sort,
                            child: Text(sort.label),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),

                // Active Filters Badge Chip
                Obx(() {
                  final count = exploreController.activeFilterCount;
                  if (count == 0) return const SizedBox.shrink();

                  return ActionChip(
                    avatar: const Icon(Icons.filter_alt_rounded,
                        size: 14, color: Colors.white),
                    label: Text('$count Active Filters (Clear)'),
                    backgroundColor: AppColors.caramel,
                    labelStyle: const TextStyle(
                      color: AppColors.espressoDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                    onPressed: () => exploreController.clearAdvancedFilters(),
                  );
                }),
              ],
            ),
            const SizedBox(height: 20),

            // Menu Items Grid Section
            Text(
              'Café Menu Items',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),

            // Reactive Product Grid / Empty State / Loading State
            Obx(() {
              if (exploreController.isLoading.value) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(AppColors.caramel),
                    ),
                  ),
                );
              }

              final products = exploreController.filteredProducts;

              if (products.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: EmptyState(
                    icon: Icons.search_off_rounded,
                    title: 'No coffee found',
                    description:
                        'Try searching for another coffee, changing category or resetting filters.',
                    actionLabel: 'Reset All Filters',
                    onAction: () => exploreController.resetAll(),
                  ),
                );
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.68,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];

                  return ProductCard(
                    productId: product.id,
                    imageUrl: product.image,
                    name: product.name,
                    category: product.category,
                    price: product.basePrice,
                    rating: product.rating,
                    reviewCount: product.reviewsCount,
                    showSubtleShadow: true,
                    onTap: () {
                      Get.find<ProductDetailsController>().initProduct(product);
                      Get.to(() => ProductsPage(productId: product.id));
                    },
                  );
                },
              );
            }),

            const SizedBox(height: 28),

            // Nearby Cafes Section
            Text(
              'Nearby Brewora Cafes',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),

            CafeCard(
              imageUrl: 'assets/images/cafes/flagship_store.jpg',
              name: 'Brewora Flagship Store',
              address: '123 5th Avenue, NYC',
              rating: 4.9,
              distance: 0.4,
              isOpen: true,
              openingHours: '7:00 AM - 9:00 PM',
              onTap: () => Get.toNamed('/digital-menu'),
            ),
            const SizedBox(height: 12),
            CafeCard(
              imageUrl: 'assets/images/cafes/roastery.jpg',
              name: 'Brewora Roastery Lab',
              address: '456 Grand St, Brooklyn, NY',
              rating: 4.8,
              distance: 1.2,
              isOpen: true,
              openingHours: '6:30 AM - 10:00 PM',
              onTap: () => Get.toNamed('/digital-menu'),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    double tempMaxPrice = exploreController.maxPrice.value;
    double tempMinRating = exploreController.minRating.value;
    bool tempOnlyHot = exploreController.onlyHot.value;
    bool tempOnlyIced = exploreController.onlyIced.value;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF181614) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Clear Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Advanced Filters',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            tempMaxPrice = 20.0;
                            tempMinRating = 0.0;
                            tempOnlyHot = false;
                            tempOnlyIced = false;
                          });
                        },
                        child: const Text(
                          'Reset',
                          style: TextStyle(
                            color: AppColors.caramel,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 12),

                  // Max Price Slider
                  Text(
                    'Max Price: \$${tempMaxPrice.toStringAsFixed(1)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: tempMaxPrice,
                    min: 3.0,
                    max: 20.0,
                    divisions: 17,
                    activeColor: AppColors.caramel,
                    label: '\$${tempMaxPrice.toStringAsFixed(1)}',
                    onChanged: (val) {
                      setModalState(() => tempMaxPrice = val);
                    },
                  ),
                  const SizedBox(height: 12),

                  // Minimum Rating Choice
                  Text(
                    'Minimum Rating: ${tempMinRating == 0.0 ? "Any" : "$tempMinRating+ ★"}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [0.0, 4.0, 4.5, 4.8].map((ratingVal) {
                      final isSel = tempMinRating == ratingVal;
                      return ChoiceChip(
                        label: Text(
                          ratingVal == 0.0 ? 'Any' : '$ratingVal+ ★',
                        ),
                        selected: isSel,
                        selectedColor: AppColors.caramel,
                        labelStyle: TextStyle(
                          color: isSel ? AppColors.espressoDark : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        onSelected: (_) {
                          setModalState(() => tempMinRating = ratingVal);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Coffee Type Switches
                  SwitchListTile(
                    title: const Text('Hot Coffee Only'),
                    activeColor: AppColors.caramel,
                    value: tempOnlyHot,
                    onChanged: (val) {
                      setModalState(() {
                        tempOnlyHot = val;
                        if (val) tempOnlyIced = false;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Iced / Cold Coffee Only'),
                    activeColor: AppColors.caramel,
                    value: tempOnlyIced,
                    onChanged: (val) {
                      setModalState(() {
                        tempOnlyIced = val;
                        if (val) tempOnlyHot = false;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            exploreController.applyAdvancedFilters(
                              maxPriceVal: tempMaxPrice,
                              minRatingVal: tempMinRating,
                              hotVal: tempOnlyHot,
                              icedVal: tempOnlyIced,
                            );
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.espressoDark,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Apply Filters',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

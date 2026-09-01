import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/controllers/favorites_controller.dart';
import '../../../../app/controllers/product_details_controller.dart';
import '../../../../app/controllers/products_controller.dart';
import '../../../../app/controllers/profile_controller.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/buttons/cart_badge_icon_button.dart';
import '../../../../core/widgets/table/table_session_banner.dart';
import '../../../../core/widgets/cards/product_card.dart';
import '../widgets/home_product_card.dart';
import '../../../../core/widgets/common/empty_state.dart';
import '../../../../core/widgets/inputs/search_field.dart';
import '../../../products/presentation/pages/products_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsController = Get.find<ProductsController>();
    final favoritesController = Get.find<FavoritesController>();
    final profileController = Get.find<ProfileController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Top App Header
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.caramel.withOpacity(0.2),
                            border: Border.all(
                              color: AppColors.caramel,
                              width: 1.5,
                            ),
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            color: AppColors.caramel,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => Text(
                                'Good day, ${profileController.user.value.name.split(' ').first} ☕',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_rounded,
                                  size: 14,
                                  color: AppColors.caramel,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '5th Avenue Store, NYC',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppColors.getTextMutedColor(
                                          Theme.of(context).brightness,
                                        ),
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkCardBg
                                : AppColors.lightSecondaryBg,
                            shape: BoxShape.circle,
                          ),
                          child: const CartBadgeIconButton(),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkCardBg
                                : AppColors.lightSecondaryBg,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.notifications_none_rounded),
                            color: AppColors.getTextColor(
                              Theme.of(context).brightness,
                            ),
                            onPressed: () => Get.toNamed('/notifications'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Table Session Banner
            const SliverToBoxAdapter(
              child: TableSessionBanner(),
            ),

            // Search Bar
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              sliver: SliverToBoxAdapter(
                child: SearchField(
                  hintText: 'Search your favorite coffee...',
                  onChanged: (val) => productsController.setSearchQuery(val),
                  onClear: () => productsController.setSearchQuery(''),
                ),
              ),
            ),

            // Hero Promo Banner
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverToBoxAdapter(
                child: Container(
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [AppColors.espressoDark, Color(0xFF4A2E20)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.espressoDark.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -20,
                        bottom: -20,
                        child: Icon(
                          Icons.local_cafe_rounded,
                          size: 180,
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.caramel,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'PROMO 20% OFF',
                                style: TextStyle(
                                  color: AppColors.espressoDark,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Get 20% off your\nCold Brew order',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Category Selector with Uniform Image Cards
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Categories',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 96,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: productsController.categories.length,
                        itemBuilder: (context, index) {
                          final cat = productsController.categories[index];
                          final imagePath = _getCategoryImage(cat);
                          final catIcon = _getCategoryIcon(cat);

                          return Obx(() {
                            final isSelected =
                                productsController.selectedCategory.value ==
                                    cat;

                            return GestureDetector(
                              onTap: () => productsController.setCategory(cat),
                              behavior: HitTestBehavior.opaque,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.only(right: 12),
                                width: 72,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Fixed 56x56 uniform image container
                                    Container(
                                      width: 56,
                                      height: 56,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: isSelected
                                              ? AppColors.caramel
                                              : (isDark
                                                  ? Colors.white
                                                      .withValues(alpha: 0.12)
                                                  : Colors.black
                                                      .withValues(alpha: 0.08)),
                                          width: isSelected ? 2.0 : 1.0,
                                        ),
                                        boxShadow: isSelected
                                            ? [
                                                BoxShadow(
                                                  color: AppColors.caramel
                                                      .withValues(alpha: 0.30),
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ]
                                            : null,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(14),
                                        child: imagePath != null
                                            ? Image.asset(
                                                imagePath,
                                                fit: BoxFit.cover,
                                                alignment: Alignment.center,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return _buildFallbackIconContainer(
                                                    context,
                                                    catIcon,
                                                    isSelected,
                                                    isDark,
                                                  );
                                                },
                                              )
                                            : _buildFallbackIconContainer(
                                                context,
                                                catIcon,
                                                isSelected,
                                                isDark,
                                              ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      cat,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.w500,
                                        color: isSelected
                                            ? (isDark
                                                ? AppColors.caramel
                                                : AppColors.espressoDark)
                                            : AppColors.getTextColor(
                                                Theme.of(context).brightness),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Featured Products Horizontal List
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Featured Coffee',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 280,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  itemCount: productsController.popularProducts.length,
                  itemBuilder: (context, index) {
                    final product = productsController.popularProducts[index];
                    return Obx(() {
                      final isFav = favoritesController.isFavorite(product.id);
                      return Container(
                        width: 175,
                        margin: const EdgeInsets.only(right: 14),
                        child: HomeProductCard(
                          product: product,
                          isFavorite: isFav,
                          showSubtleShadow: true,
                          onFavoritePressed: () =>
                              favoritesController.toggleFavorite(product.id),
                          onTap: () {
                            Get.find<ProductDetailsController>()
                                .initProduct(product);
                            Get.to(
                              () => ProductsPage(productId: product.id),
                            );
                          },
                        ),
                      );
                    });
                  },
                ),
              ),
            ),

            // Filtered Products Section Title
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'All Coffee Menu',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),

            // Main Product Grid
            Obx(() {
              final products = productsController.filteredProducts;
              if (products.isEmpty) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: EmptyState(
                      icon: Icons.search_off_rounded,
                      title: 'No coffee found',
                      description:
                          'Try searching for another coffee or choose a different category.',
                      actionLabel: 'Reset Filters',
                      onAction: () {
                        productsController.resetFilters();
                      },
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.68,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = products[index];
                      return Obx(() {
                        final isFav =
                            favoritesController.isFavorite(product.id);
                        return HomeProductCard(
                          product: product,
                          isFavorite: isFav,
                          showSubtleShadow: true,
                          onFavoritePressed: () =>
                              favoritesController.toggleFavorite(product.id),
                          onTap: () {
                            Get.find<ProductDetailsController>()
                                .initProduct(product);
                            Get.to(
                              () => ProductsPage(productId: product.id),
                            );
                          },
                        );
                      });
                    },
                    childCount: products.length,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  String? _getCategoryImage(String category) {
    switch (category) {
      case 'Hot Coffee':
        return 'assets/images/coffee/cappuccino.jpg';
      case 'Iced Coffee':
        return 'assets/images/coffee/iced_latte.jpg';
      case 'Specialty':
        return 'assets/images/coffee/caramel_latte.jpg';
      case 'Non-Coffee':
        return 'assets/images/coffee/matcha_latte.jpg';
      default:
        return null;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'All':
        return Icons.coffee_rounded;
      case 'Hot Coffee':
        return Icons.local_cafe_rounded;
      case 'Iced Coffee':
        return Icons.ac_unit_rounded;
      case 'Specialty':
        return Icons.star_rounded;
      case 'Non-Coffee':
        return Icons.eco_rounded;
      default:
        return Icons.coffee_rounded;
    }
  }

  Widget _buildFallbackIconContainer(
    BuildContext context,
    IconData icon,
    bool isSelected,
    bool isDark,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.caramel.withValues(alpha: 0.20)
            : (isDark ? AppColors.darkCardBg : AppColors.lightSecondaryBg),
      ),
      child: Center(
        child: Icon(
          icon,
          size: 24,
          color: isSelected
              ? (isDark ? AppColors.caramel : AppColors.espressoDark)
              : AppColors.getTextMutedColor(Theme.of(context).brightness),
        ),
      ),
    );
  }
}

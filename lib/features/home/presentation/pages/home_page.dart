import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/controllers/favorites_controller.dart';
import '../../../../app/controllers/product_details_controller.dart';
import '../../../../app/controllers/products_controller.dart';
import '../../../../app/controllers/profile_controller.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/cards/product_card.dart';
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
              ),
            ),

            // Search Bar
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              sliver: SliverToBoxAdapter(
                child: SearchField(
                  hintText: 'Search your favorite coffee...',
                  onChanged: (val) => productsController.setSearchQuery(val),
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

            // Category Chips Selector
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
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: productsController.categories.length,
                        itemBuilder: (context, index) {
                          final cat = productsController.categories[index];
                          return Obx(() {
                            final isSelected =
                                productsController.selectedCategory.value == cat;
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
                                          Theme.of(context).brightness,
                                        ),
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                                onSelected: (_) =>
                                    productsController.setCategory(cat),
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
                height: 265,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: productsController.popularProducts.length,
                  itemBuilder: (context, index) {
                    final product = productsController.popularProducts[index];
                    return Obx(() {
                      final isFav =
                          favoritesController.isFavorite(product.id);
                      return Container(
                        width: 175,
                        margin: const EdgeInsets.only(right: 12),
                        child: ProductCard(
                          imageUrl: product.image,
                          name: product.name,
                          category: product.category,
                          price: product.basePrice,
                          rating: product.rating,
                          reviewCount: product.reviewsCount,
                          isFavorite: isFav,
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
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(
                      child: Text('No coffee items match your search.'),
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
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
                        return ProductCard(
                          imageUrl: product.image,
                          name: product.name,
                          category: product.category,
                          price: product.basePrice,
                          rating: product.rating,
                          reviewCount: product.reviewsCount,
                          isFavorite: isFav,
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
}

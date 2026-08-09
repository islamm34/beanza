import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/controllers/favorites_controller.dart';
import '../../../../app/controllers/product_details_controller.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/data/local_product_catalog.dart';

class ProductsPage extends StatelessWidget {
  final String productId;

  const ProductsPage({
    this.productId = 'prod_1',
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final detailsController = Get.find<ProductDetailsController>();
    final favoritesController = Get.find<FavoritesController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Fallback if product not initialized yet
    final product = LocalProductCatalog.products.firstWhere(
      (p) => p.id == productId,
      orElse: () => LocalProductCatalog.products.first,
    );

    if (detailsController.product.id != product.id) {
      detailsController.initProduct(product);
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // App Bar with Large Hero Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: isDark
                    ? Colors.black.withOpacity(0.5)
                    : Colors.white.withOpacity(0.8),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                  color: AppColors.getTextColor(Theme.of(context).brightness),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(() {
                  final isFav = favoritesController.isFavorite(product.id);
                  return CircleAvatar(
                    backgroundColor: isDark
                        ? Colors.black.withOpacity(0.5)
                        : Colors.white.withOpacity(0.8),
                    child: IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? AppColors.error : AppColors.caramel,
                      ),
                      onPressed: () =>
                          favoritesController.toggleFavorite(product.id),
                    ),
                  );
                }),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    product.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.softSand,
                      child: const Icon(Icons.local_cafe, size: 80),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          (isDark ? AppColors.darkBg : AppColors.lightBg)
                              .withOpacity(0.8),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Details Body
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category tag & rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.caramel.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          product.category,
                          style: const TextStyle(
                            color: AppColors.caramel,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              color: AppColors.warning, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            '${product.rating}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' (${product.reviewsCount} reviews)',
                            style: TextStyle(
                              color: AppColors.getTextMutedColor(
                                Theme.of(context).brightness,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Title & Description
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.getTextMutedColor(
                            Theme.of(context).brightness,
                          ),
                          height: 1.5,
                        ),
                  ),
                  const SizedBox(height: 20),

                  // Nutrition Stats (Calories & Caffeine)
                  Row(
                    children: [
                      _buildNutriBadge(
                        context,
                        Icons.local_fire_department_rounded,
                        '${product.calories} kcal',
                      ),
                      const SizedBox(width: 12),
                      _buildNutriBadge(
                        context,
                        Icons.bolt_rounded,
                        '${product.caffeine} mg Caffeine',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(),

                  // Size Selection
                  const SizedBox(height: 12),
                  Text(
                    'Select Size',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: product.sizes.map((size) {
                      return Expanded(
                        child: Obx(() {
                          final isSelected =
                              detailsController.selectedSize.value.name ==
                                  size.name;
                          return GestureDetector(
                            onTap: () => detailsController.selectSize(size),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.espressoDark
                                    : (isDark
                                        ? AppColors.darkCardBg
                                        : AppColors.lightSecondaryBg),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.caramel
                                      : Colors.transparent,
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    size.name,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : AppColors.getTextColor(
                                              Theme.of(context).brightness,
                                            ),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    size.volume,
                                    style: TextStyle(
                                      color: isSelected
                                          ? AppColors.caramel
                                          : AppColors.getTextMutedColor(
                                              Theme.of(context).brightness,
                                            ),
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Milk Option Selection
                  Text(
                    'Choice of Milk',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: product.milkOptions.map((milk) {
                      return Obx(() {
                        final isSelected =
                            detailsController.selectedMilk.value.name ==
                                milk.name;
                        return ChoiceChip(
                          label: Text(
                            milk.additionalPrice > 0
                                ? '${milk.name} (+\$${milk.additionalPrice.toStringAsFixed(2)})'
                                : milk.name,
                          ),
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
                              detailsController.selectMilk(milk),
                        );
                      });
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Extras Selection
                  Text(
                    'Extra Add-ons',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    children: product.extras.map((extra) {
                      return Obx(() {
                        final isSelected =
                            detailsController.selectedExtras.contains(extra);
                        return CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(extra.name),
                          subtitle: Text('+\$${extra.price.toStringAsFixed(2)}'),
                          activeColor: AppColors.caramel,
                          checkColor: AppColors.espressoDark,
                          value: isSelected,
                          onChanged: (_) =>
                              detailsController.toggleExtra(extra),
                        );
                      });
                    }).toList(),
                  ),
                  const SizedBox(height: 100), // Bottom padding for sticky bar
                ],
              ),
            ),
          ),
        ],
      ),

      // Sticky Bottom Price & Add to Cart Bar
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCardBg : AppColors.lightCardBg,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Quantity Selector
            Container(
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSecondaryBg
                    : AppColors.lightSecondaryBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, size: 18),
                    onPressed: () => detailsController.decrementQuantity(),
                  ),
                  Obx(
                    () => Text(
                      '${detailsController.quantity.value}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, size: 18),
                    onPressed: () => detailsController.incrementQuantity(),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // Add to Cart Button with Computed Total Price
            Expanded(
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: () => detailsController.addToCart(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.espressoDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Add to Cart',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '\$${detailsController.totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: AppColors.caramel,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutriBadge(BuildContext context, IconData icon, String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : AppColors.lightSecondaryBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.caramel),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

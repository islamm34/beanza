import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glassy/glassy_card.dart';
import 'package:glassy/glassy_config.dart';

import '../../../../app/controllers/cart_controller.dart';
import '../../../../app/controllers/favorites_controller.dart';
import '../../../../app/controllers/products_controller.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/common/app_app_bar.dart';
import '../../../../core/widgets/inputs/search_field.dart';

class DigitalMenuPage extends StatefulWidget {
  final String cafeId;

  const DigitalMenuPage({this.cafeId = 'cafe_1', Key? key}) : super(key: key);

  @override
  State<DigitalMenuPage> createState() => _DigitalMenuPageState();
}

class _DigitalMenuPageState extends State<DigitalMenuPage> {
  final productsController = Get.find<ProductsController>();
  final cartController = Get.find<CartController>();
  final favoritesController = Get.find<FavoritesController>();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const AppAppBar(
        title: 'Brewora Digital Menu',
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Input
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: SearchField(
                hintText: 'Search digital menu...',
                onChanged: (val) => productsController.setSearchQuery(val),
              ),
            ),

            // Horizontal Categories
            SizedBox(
              height: 48,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: productsController.categories.length,
                itemBuilder: (context, index) {
                  final category = productsController.categories[index];

                  return Obx(() {
                    final isSelected =
                        productsController.selectedCategory.value == category;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(category),
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
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        onSelected: (_) =>
                            productsController.setCategory(category),
                      ),
                    );
                  });
                },
              ),
            ),

            const SizedBox(height: 8),

            // Menu Items List
            Expanded(
              child: Obx(() {
                final products = productsController.filteredProducts;

                if (products.isEmpty) {
                  return const Center(
                    child: Text('No menu items match your search.'),
                  );
                }

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final isFav = favoritesController.isFavorite(product.id);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: GlassyCard(
                        config: GlassyConfig(
                          radius: 18,
                          backgroundColor: isDark
                              ? AppColors.darkCardBg
                              : Colors.white,
                          backgroundOpacity: isDark ? 0.60 : 0.70,
                          borderColor: isDark
                              ? Colors.white
                              : AppColors.espressoDark,
                          borderOpacity: isDark ? 0.15 : 0.08,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              // Product Image Thumbnail
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  color: isDark
                                      ? AppColors.darkCardBg
                                      : AppColors.softSand,
                                  child: Image.asset(
                                    product.image,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(
                                      Icons.coffee_rounded,
                                      color: AppColors.caramel,
                                      size: 32,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),

                              // Info Column
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            product.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => favoritesController
                                              .toggleFavorite(product.id),
                                          child: Icon(
                                            isFav
                                                ? Icons.favorite_rounded
                                                : Icons.favorite_border_rounded,
                                            color: isFav
                                                ? AppColors.error
                                                : AppColors.textMuted,
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      product.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.getTextMutedColor(
                                          Theme.of(context).brightness,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '\$${product.basePrice.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.coffeeBrown,
                                          ),
                                        ),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            cartController.addProduct(product);
                                            Get.snackbar(
                                              'Added to Cart ☕',
                                              '${product.name} added to your order.',
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              backgroundColor:
                                                  AppColors.espressoDark,
                                              colorText: Colors.white,
                                              margin: const EdgeInsets.all(16),
                                              duration:
                                                  const Duration(seconds: 2),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.caramel,
                                            foregroundColor:
                                                AppColors.espressoDark,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            minimumSize: Size.zero,
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          icon: const Icon(
                                            Icons.add_rounded,
                                            size: 16,
                                          ),
                                          label: const Text(
                                            'Add',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

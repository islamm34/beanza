import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glassy/glassy_card.dart';
import 'package:glassy/glassy_config.dart';

import '../../../../app/controllers/cart_controller.dart';
import '../../../../app/controllers/favorites_controller.dart';
import '../../../../app/controllers/products_controller.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/buttons/favorite_button.dart';
import '../../../../core/widgets/common/app_app_bar.dart';
import '../../../../core/widgets/common/empty_state.dart';
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
      appBar: AppAppBar(
        title: 'digital_menu_title'.tr,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Input
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: SearchField(
                hintText: 'search_digital_menu_hint'.tr,
                onChanged: (val) => productsController.setSearchQuery(val),
                onClear: () => productsController.setSearchQuery(''),
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
                        label: Text(productsController.getLocalizedCategoryName(category)),
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
                  return EmptyState(
                    icon: Icons.search_off_rounded,
                    title: 'digital_menu_no_coffee'.tr,
                    description: 'digital_menu_no_coffee_desc'.tr,
                    actionLabel: 'reset_filters'.tr,
                    onAction: () {
                      productsController.resetFilters();
                    },
                  );
                }

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: GlassyCard(
                        config: GlassyConfig(
                          radius: 18,
                          backgroundColor:
                              isDark ? AppColors.darkCardBg : Colors.white,
                          backgroundOpacity: isDark ? 0.60 : 0.70,
                          borderColor:
                              isDark ? Colors.white : AppColors.espressoDark,
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
                                            product.localizedName,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        FavoriteButton(
                                          productId: product.id,
                                          showBackground: false,
                                          iconSize: 20,
                                          size: 28,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      product.localizedDescription,
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
                                          '${product.basePrice.toStringAsFixed(2)} ${'egp'.tr}',
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
                                              'added_to_cart'.tr,
                                              'item_added_to_cart_desc'.trParams({'name': product.localizedName}),
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
                                          label: Text(
                                            'add'.tr,
                                            style: const TextStyle(
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

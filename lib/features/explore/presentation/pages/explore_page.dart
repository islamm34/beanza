import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/controllers/products_controller.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/cards/cafe_card.dart';
import '../../../../core/widgets/common/app_app_bar.dart';
import '../../../../core/widgets/inputs/search_field.dart';
import '../../../../core/widgets/table/table_session_banner.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsController = Get.find<ProductsController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const AppAppBar(
        title: 'Explore Cafes & Menu',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TableSessionBanner(),
            // Search Input
            SearchField(
              hintText: 'Search coffee shops or items...',
              onChanged: (val) => productsController.setSearchQuery(val),
            ),
            const SizedBox(height: 16),

            // Category Chips
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
                                  Theme.of(context).brightness),
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        onSelected: (_) => productsController.setCategory(cat),
                      ),
                    );
                  });
                },
              ),
            ),
            const SizedBox(height: 24),

            // Section Header
            Text(
              'Nearby Brewora Cafes',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),

            // Cafe List
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
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/controllers/product_details_controller.dart';
import '../../../../app/controllers/products_controller.dart';
import '../../../../app/controllers/profile_controller.dart';
import '../../../../app/controllers/table_session_controller.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/buttons/cart_badge_icon_button.dart';
import '../../../../core/widgets/common/empty_state.dart';
import '../../../../core/widgets/inputs/search_field.dart';
import '../../../products/presentation/pages/products_page.dart';
import '../widgets/home_product_card.dart';
import '../widgets/home_profile_header.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime? _lastProfileTap;

  void _handleProfileTap() {
    final now = DateTime.now();
    if (_lastProfileTap != null &&
        now.difference(_lastProfileTap!) < const Duration(milliseconds: 600)) {
      return;
    }
    _lastProfileTap = now;
    Get.toNamed(Routes.PROFILE);
  }

  @override
  Widget build(BuildContext context) {
    final productsController = Get.find<ProductsController>();
    final profileController = Get.find<ProfileController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldColor = isDark ? AppColors.gold : AppColors.goldLight;
    final greenColor =
        isDark ? AppColors.primaryGreen : AppColors.primaryGreenLight;

    TableSessionController? tableController;
    if (Get.isRegistered<TableSessionController>()) {
      tableController = Get.find<TableSessionController>();
    }

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 1. Top App Header & Profile Greeting
            SliverToBoxAdapter(
              child: Obx(() {
                final user = profileController.user.value;
                final tableActive = tableController?.hasActiveSession ?? false;
                final tableNum = tableController?.tableNumber;

                return HomeProfileHeader(
                  name: user.name,
                  avatarPath: user.profileImage,
                  tableNumber: tableNum,
                  hasActiveTableSession: tableActive,
                  onProfileTap: _handleProfileTap,
                  onNotificationsTap: () => Get.toNamed(Routes.NOTIFICATIONS),
                );
              }),
            ),

            // 2. Rounded Search Bar with Filter/Mic action
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(
                      child: SearchField(
                        hintText: 'search_drinks_hint'.tr,
                        onChanged: (val) =>
                            productsController.setSearchQuery(val),
                        onClear: () => productsController.setSearchQuery(''),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkCardElevated
                            : AppColors.lightSecondaryBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder,
                        ),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.tune_rounded,
                            color: goldColor, size: 20),
                        onPressed: () => Get.toNamed(Routes.EXPLORE),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 3. Current Table Chip directly below search bar
            if (tableController != null)
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                sliver: SliverToBoxAdapter(
                  child: Obx(() {
                    final hasSession = tableController!.hasActiveSession;
                    final tableNum = tableController.tableNumber;
                    final pCount = tableController.participantCount;

                    return GestureDetector(
                      onTap: () {
                        if (hasSession) {
                          Get.toNamed(Routes.TABLE_OVERVIEW);
                        } else {
                          Get.toNamed(Routes.SCANNER);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: hasSession
                              ? greenColor.withValues(
                                  alpha: isDark ? 0.16 : 0.12)
                              : (isDark
                                  ? AppColors.darkCardElevated
                                  : AppColors.lightSecondaryBg),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: hasSession
                                ? greenColor
                                : (isDark
                                    ? AppColors.darkBorder
                                    : AppColors.lightBorder),
                            width: 1.2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              hasSession
                                  ? Icons.table_restaurant_rounded
                                  : Icons.qr_code_scanner_rounded,
                              size: 18,
                              color: hasSession ? greenColor : goldColor,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                hasSession
                                    ? 'table_connected_banner'.trParams({
                                        'table': tableNum,
                                        'count': pCount.toString(),
                                      })
                                    : 'no_active_table_banner'.tr,
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: hasSession ? greenColor : goldColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                hasSession ? 'active_badge'.tr : 'scan_badge'.tr,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),

            // 4. Horizontal Categories with Gold Surface / Border when selected
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              sliver: SliverToBoxAdapter(
                child: SizedBox(
                  height: 44,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: productsController.categories.length,
                    itemBuilder: (context, index) {
                      final category = productsController.categories[index];
                      return Obx(() {
                        final isSelected =
                            productsController.selectedCategory.value ==
                                category;

                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () =>
                                productsController.setCategory(category),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? goldColor.withValues(
                                        alpha: isDark ? 0.22 : 0.16)
                                    : (isDark
                                        ? AppColors.darkCardBg
                                        : AppColors.lightCardBg),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSelected
                                      ? goldColor
                                      : (isDark
                                          ? AppColors.darkBorder
                                          : AppColors.lightBorder),
                                  width: isSelected ? 1.5 : 1.0,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  category,
                                  style: TextStyle(
                                    color: isSelected
                                        ? (isDark
                                            ? AppColors.goldBright
                                            : goldColor)
                                        : (isDark
                                            ? AppColors.darkTextSecondary
                                            : AppColors.lightTextSecondary),
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                    },
                  ),
                ),
              ),
            ),

            // 5. AI Suggestion Card with subtle green border
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              sliver: SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkCardElevated
                        : AppColors.lightCardElevated,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: greenColor.withValues(alpha: isDark ? 0.6 : 0.5),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            greenColor.withValues(alpha: isDark ? 0.12 : 0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/images/coffee/caramel_latte.jpg',
                          width: 58,
                          height: 58,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 58,
                            height: 58,
                            color: goldColor.withValues(alpha: 0.2),
                            child: const Icon(Icons.auto_awesome_rounded,
                                color: AppColors.gold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.auto_awesome_rounded,
                                    size: 14, color: goldColor),
                                const SizedBox(width: 4),
                                Text(
                                  'ai_barista_pick'.tr,
                                  style: TextStyle(
                                    color: goldColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'ai_barista_pick_name'.tr,
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.lightTextPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              'ai_barista_pick_desc'.tr,
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      ElevatedButton(
                        onPressed: () {
                          final popular = productsController.popularProducts;
                          if (popular.isNotEmpty) {
                            Get.find<ProductDetailsController>()
                                .initProduct(popular.first);
                            Get.to(() =>
                                ProductsPage(productId: popular.first.id));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: greenColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          minimumSize: const Size(60, 34),
                        ),
                        child: Text('try_btn'.tr,
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 6. Section Header with "View All"
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'featured_coffee_menu'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed(Routes.EXPLORE),
                      child: Text(
                        'view_all'.tr,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: goldColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 7. Main 2-Column Product Grid
            Obx(() {
              final products = productsController.filteredProducts;
              if (products.isEmpty) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: EmptyState(
                      icon: Icons.search_off_rounded,
                      title: 'no_coffee_found_title'.tr,
                      message: 'no_coffee_found_msg'.tr,
                      actionLabel: 'reset_filters_btn'.tr,
                      onAction: () => productsController.resetFilters(),
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = products[index];
                      return HomeProductCard(
                        product: product,
                        showSubtleShadow: true,
                        onTap: () {
                          Get.find<ProductDetailsController>()
                              .initProduct(product);
                          Get.to(() => ProductsPage(productId: product.id));
                        },
                      );
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

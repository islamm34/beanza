import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/controllers/product_details_controller.dart';
import '../../../../app/controllers/table_session_controller.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/data/local_product_catalog.dart';
import '../../../../core/widgets/buttons/favorite_button.dart';
import '../../../../core/widgets/common/cafe_card.dart';
import '../../../../core/widgets/table/select_person_sheet.dart';

class ProductsPage extends StatefulWidget {
  final String productId;

  const ProductsPage({
    this.productId = 'prod_1',
    Key? key,
  }) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String _selectedRoast = 'Medium';
  int _sugarPercentage = 50;
  String _assignedToName = 'Myself';
  String? _assignedParticipantId;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<TableSessionController>()) {
      final tableCtrl = Get.find<TableSessionController>();
      final me = tableCtrl.currentParticipant.value;
      if (me != null) {
        _assignedToName = me.displayName;
        _assignedParticipantId = me.participantId;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final detailsController = Get.find<ProductDetailsController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldColor = isDark ? AppColors.gold : AppColors.goldLight;
    final greenColor =
        isDark ? AppColors.primaryGreen : AppColors.primaryGreenLight;

    final product = LocalProductCatalog.products.firstWhere(
      (p) => p.id == widget.productId,
      orElse: () => LocalProductCatalog.products.first,
    );

    if (detailsController.product.id != product.id) {
      detailsController.initProduct(product);
    }

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. App Bar with Hero Product Image
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.6)
                      : Colors.white.withValues(alpha: 0.85),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 16,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FavoriteButton(
                  productId: product.id,
                  size: 40,
                  iconSize: 20,
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  product.image.startsWith('assets/')
                      ? Image.asset(
                          product.image,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _buildFallbackImage(isDark),
                        )
                      : Image.network(
                          product.image,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _buildFallbackImage(isDark),
                        ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          (isDark ? AppColors.darkBg : AppColors.lightBg)
                              .withValues(alpha: 0.85),
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

          // 2. Customization Body
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Localized Product Name
                  Text(
                    product.localizedName,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.localizedCategory,
                    style: TextStyle(
                      fontSize: 13,
                      color: goldColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product.localizedDescription,
                    style: TextStyle(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Nutrition / Stats
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildNutriBadge(
                          Icons.local_fire_department_rounded,
                          'calories_unit'.trParams({'count': product.calories.toString()}),
                          isDark),
                      _buildNutriBadge(
                          Icons.bolt_rounded,
                          'caffeine_unit'.trParams({'count': product.caffeine.toString()}),
                          isDark),
                      _buildNutriBadge(
                          Icons.star_rounded,
                          '${product.rating} (${product.reviewsCount})',
                          isDark),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Divider(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.lightBorder),
                  const SizedBox(height: 16),

                  // Group 1: Cup Size (S, M, L, XL)
                  Text(
                    'choose_size_title'.tr,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
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
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: CafeOptionChip(
                              label: size.localizedName,
                              subtitle: size.volume,
                              isSelected: isSelected,
                              onTap: () => detailsController.selectSize(size),
                            ),
                          );
                        }),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Group 2: Coffee Roast (Light, Medium, Dark)
                  Text(
                    'roast_title'.tr,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      {'key': 'Light', 'label': 'light_roast'.tr},
                      {'key': 'Medium', 'label': 'medium_roast'.tr},
                      {'key': 'Dark', 'label': 'dark_roast'.tr},
                    ].map((roastItem) {
                      final roastKey = roastItem['key']!;
                      final roastLabel = roastItem['label']!;
                      final isSelected = _selectedRoast == roastKey;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: CafeOptionChip(
                            label: roastLabel,
                            icon: Icons.coffee_rounded,
                            isSelected: isSelected,
                            onTap: () => setState(() => _selectedRoast = roastKey),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Group 3: Sugar Level Selector
                  Text(
                    '${'sugar_level_title'.tr}: $_sugarPercentage%',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [0, 25, 50, 75, 100].map((sugar) {
                      final isSelected = _sugarPercentage == sugar;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: CafeOptionChip(
                            label: '$sugar%',
                            isSelected: isSelected,
                            onTap: () =>
                                setState(() => _sugarPercentage = sugar),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Group 4: Choice of Milk
                  Text(
                    'milk_options_title'.tr,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
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
                        return CafeOptionChip(
                          label: milk.localizedName,
                          trailing: milk.additionalPrice > 0
                              ? '+${milk.additionalPrice.toStringAsFixed(0)} ${'egp'.tr}'
                              : null,
                          isSelected: isSelected,
                          onTap: () => detailsController.selectMilk(milk),
                        );
                      });
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Group 5: Extra Add-ons
                  Text(
                    'extras_title'.tr,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...product.extras.map((extra) {
                    return Obx(() {
                      final isSelected =
                          detailsController.selectedExtras.contains(extra);
                      return CafeCard(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        borderColor: isSelected
                            ? goldColor
                            : (isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder),
                        onTap: () => detailsController.toggleExtra(extra),
                        child: Row(
                          children: [
                            Icon(
                              isSelected
                                  ? Icons.check_box_rounded
                                  : Icons.check_box_outline_blank_rounded,
                              color: isSelected
                                  ? goldColor
                                  : (isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary),
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                extra.localizedName,
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '+${extra.price.toStringAsFixed(2)} ${'egp'.tr}',
                              style: TextStyle(
                                color: goldColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      );
                    });
                  }),
                  const SizedBox(height: 20),

                  // Group 6: Assign To Person Card
                  Text(
                    'who_is_this_order_for'.tr,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  CafeCard(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    onTap: () async {
                      final selectedId = await SelectPersonSheet.show(
                        context,
                        currentSelectedId: _assignedParticipantId,
                      );
                      if (selectedId != null &&
                          Get.isRegistered<TableSessionController>()) {
                        final tableCtrl = Get.find<TableSessionController>();
                        final p = tableCtrl.currentSession.value?.participants
                            .firstWhereOrNull(
                                (part) => part.participantId == selectedId);
                        setState(() {
                          _assignedParticipantId = selectedId;
                          _assignedToName = p?.displayName ??
                              (selectedId == 'guest' ? 'for_table_companion'.tr : 'for_myself'.tr);
                        });
                      }
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: goldColor.withValues(alpha: 0.2),
                          child: Icon(Icons.person_rounded,
                              color: goldColor, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _assignedToName,
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'for_table_companion'.tr,
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
                        Icon(Icons.arrow_forward_ios_rounded,
                            size: 14, color: goldColor),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // 3. Sticky Bottom Price & Add to Shared Cart Button
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCardBg : AppColors.lightCardBg,
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              width: 1.2,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Quantity Stepper
              Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkCardElevated
                      : AppColors.lightSecondaryBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color:
                        isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_rounded, size: 18),
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                      onPressed: () => detailsController.decrementQuantity(),
                    ),
                    Obx(
                      () => Text(
                        '${detailsController.quantity.value}',
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_rounded, size: 18),
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                      onPressed: () => detailsController.incrementQuantity(),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),

              // Add to Shared Cart Button
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      if (Get.isRegistered<TableSessionController>() &&
                          Get.find<TableSessionController>().hasActiveSession) {
                        final tableCtrl = Get.find<TableSessionController>();
                        tableCtrl.addItemToTableOrder(
                          product: product,
                          size: detailsController.selectedSize.value,
                          milk: detailsController.selectedMilk.value,
                          extras: detailsController.selectedExtras.toList(),
                          quantity: detailsController.quantity.value,
                        );
                        Get.snackbar(
                          'item_added_to_shared_cart'.trParams({'name': product.localizedName}),
                          'item_added_to_shared_cart'.trParams({'name': product.localizedName}),
                          backgroundColor: isDark
                              ? AppColors.darkCardBg
                              : AppColors.lightCardBg,
                          colorText: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        );
                        Navigator.pop(context);
                      } else {
                        detailsController.addToCart();
                        Get.snackbar(
                          'item_added_to_cart'.trParams({'name': product.localizedName}),
                          'item_added_to_cart'.trParams({'name': product.localizedName}),
                          backgroundColor: isDark
                              ? AppColors.darkCardBg
                              : AppColors.lightCardBg,
                          colorText: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        );
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: greenColor,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Obx(
                      () => FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              (Get.isRegistered<TableSessionController>() &&
                                      Get.find<TableSessionController>()
                                          .hasActiveSession)
                                  ? 'add_to_shared_cart'.tr
                                  : 'add_to_cart'.tr,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13.5,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '• ${detailsController.totalPrice.toStringAsFixed(2)} ${'egp'.tr}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutriBadge(IconData icon, String text, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardElevated : AppColors.lightSecondaryBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 14, color: isDark ? AppColors.gold : AppColors.goldLight),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackImage(bool isDark) {
    return Container(
      color: isDark ? AppColors.darkCardElevated : AppColors.lightSecondaryBg,
      child: Center(
        child: Icon(
          Icons.local_cafe_rounded,
          size: 64,
          color: isDark ? AppColors.gold : AppColors.goldLight,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/controllers/cart_controller.dart';
import '../../../../app/controllers/table_session_controller.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/common/app_app_bar.dart';
import '../../../../core/widgets/common/cafe_card.dart';
import '../../../../core/widgets/common/empty_state.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int _selectedFilterIndex = 0; // 0 = All Items, 1 = By Person

  static const List<Color> _avatarColors = [
    Color(0xFF31A93D),
    Color(0xFFD0932F),
    Color(0xFF29B6F6),
    Color(0xFFAB47BC),
  ];

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldColor = isDark ? AppColors.gold : AppColors.goldLight;
    final greenColor =
        isDark ? AppColors.primaryGreen : AppColors.primaryGreenLight;

    TableSessionController? tableController;
    if (Get.isRegistered<TableSessionController>()) {
      tableController = Get.find<TableSessionController>();
    }

    final tableCtrl = tableController;
    final hasTableSession = tableCtrl != null && tableCtrl.hasActiveSession;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppAppBar(
        title: hasTableSession && tableCtrl != null
            ? 'Table ${tableCtrl.tableNumber} Cart'
            : 'Your Coffee Cart',
        showCartAction: false,
      ),
      body: SafeArea(
        child: Obx(() {
          // If in table session with shared items
          if (hasTableSession &&
              tableCtrl != null &&
              tableCtrl.orderItems.isNotEmpty) {
            final session = tableCtrl.currentSession.value;
            final participants = session?.participants ?? [];
            final totalAmount = tableCtrl.total;

            return Column(
              children: [
                // 1. Top Segmented Filters: "All Items" / "By Person"
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    padding: const EdgeInsets.all(4),
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
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _selectedFilterIndex = 0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: _selectedFilterIndex == 0
                                    ? goldColor.withValues(
                                        alpha: isDark ? 0.25 : 0.18)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                border: _selectedFilterIndex == 0
                                    ? Border.all(color: goldColor, width: 1.2)
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  'All Items (${tableCtrl.totalItemCount})',
                                  style: TextStyle(
                                    color: _selectedFilterIndex == 0
                                        ? (isDark
                                            ? AppColors.goldBright
                                            : goldColor)
                                        : (isDark
                                            ? AppColors.darkTextSecondary
                                            : AppColors.lightTextSecondary),
                                    fontWeight: _selectedFilterIndex == 0
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _selectedFilterIndex = 1),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: _selectedFilterIndex == 1
                                    ? goldColor.withValues(
                                        alpha: isDark ? 0.25 : 0.18)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                border: _selectedFilterIndex == 1
                                    ? Border.all(color: goldColor, width: 1.2)
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  'By Person (${participants.length})',
                                  style: TextStyle(
                                    color: _selectedFilterIndex == 1
                                        ? (isDark
                                            ? AppColors.goldBright
                                            : goldColor)
                                        : (isDark
                                            ? AppColors.darkTextSecondary
                                            : AppColors.lightTextSecondary),
                                    fontWeight: _selectedFilterIndex == 1
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    fontSize: 13,
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

                // 2. Small Live Updates Bar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: greenColor.withValues(alpha: isDark ? 0.14 : 0.10),
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: greenColor.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.sync_rounded,
                            color: AppColors.brightGreen, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Live Table Updates: ${participants.length} members connected • Synced',
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.lightTextPrimary,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 3. Grouped Items List
                Expanded(
                  child: ListView(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      ...participants.asMap().entries.map((entry) {
                        final index = entry.key;
                        final p = entry.value;
                        final items =
                            tableController!.participantItems(p.participantId);
                        if (items.isEmpty && _selectedFilterIndex == 0) {
                          return const SizedBox.shrink();
                        }

                        return CafeCard(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Member Header
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: _avatarColors[
                                        index % _avatarColors.length],
                                    child: Text(
                                      p.displayName.isNotEmpty
                                          ? p.displayName[0].toUpperCase()
                                          : 'U',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      p.displayName,
                                      style: TextStyle(
                                        color: isDark
                                            ? AppColors.darkTextPrimary
                                            : AppColors.lightTextPrimary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  CafeBadge(
                                    text: '${items.length} items',
                                    isGold: true,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Divider(
                                  color: isDark
                                      ? AppColors.darkBorder
                                      : AppColors.lightBorder),

                              // Items
                              if (items.isEmpty)
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Text(
                                    'No drinks added yet',
                                    style: TextStyle(
                                      color: isDark
                                          ? AppColors.darkTextSecondary
                                          : AppColors.lightTextSecondary,
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                )
                              else
                                ...items.map((item) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      children: [
                                        // Product Thumbnail
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: item.product.image
                                                  .startsWith('assets/')
                                              ? Image.asset(
                                                  item.product.image,
                                                  width: 44,
                                                  height: 44,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (_, __, ___) =>
                                                      Container(
                                                    width: 44,
                                                    height: 44,
                                                    color: goldColor.withValues(
                                                        alpha: 0.2),
                                                    child: const Icon(
                                                        Icons.local_cafe,
                                                        size: 20),
                                                  ),
                                                )
                                              : Image.network(
                                                  item.product.image,
                                                  width: 44,
                                                  height: 44,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (_, __, ___) =>
                                                      Container(
                                                    width: 44,
                                                    height: 44,
                                                    color: goldColor.withValues(
                                                        alpha: 0.2),
                                                    child: const Icon(
                                                        Icons.local_cafe,
                                                        size: 20),
                                                  ),
                                                ),
                                        ),
                                        const SizedBox(width: 10),

                                        // Product Details
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.product.name,
                                                style: TextStyle(
                                                  color: isDark
                                                      ? AppColors
                                                          .darkTextPrimary
                                                      : AppColors
                                                          .lightTextPrimary,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13.5,
                                                ),
                                              ),
                                              Text(
                                                '${item.selectedSize.name} • ${item.selectedMilk.name}',
                                                style: TextStyle(
                                                  color: isDark
                                                      ? AppColors
                                                          .darkTextSecondary
                                                      : AppColors
                                                          .lightTextSecondary,
                                                  fontSize: 11,
                                                ),
                                              ),
                                              Text(
                                                '${item.totalPrice.toStringAsFixed(2)} EGP x ${item.quantity}',
                                                style: TextStyle(
                                                  color: goldColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Edit / Delete Actions on the right
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                  Icons
                                                      .remove_circle_outline_rounded,
                                                  size: 20),
                                              color: isDark
                                                  ? AppColors.darkTextSecondary
                                                  : AppColors
                                                      .lightTextSecondary,
                                              onPressed: () => tableController!
                                                  .decrementItemQuantity(
                                                      item.id),
                                            ),
                                            Text(
                                              '${item.quantity}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: isDark
                                                    ? AppColors.darkTextPrimary
                                                    : AppColors
                                                        .lightTextPrimary,
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                  Icons
                                                      .add_circle_outline_rounded,
                                                  size: 20),
                                              color: greenColor,
                                              onPressed: () => tableController!
                                                  .incrementItemQuantity(
                                                      item.id),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),

                // 4. Sticky Bottom Action Bar
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color:
                        isDark ? AppColors.darkCardBg : AppColors.lightCardBg,
                    border: Border(
                      top: BorderSide(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder,
                        width: 1.2,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Table Total Amount:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Text(
                            '${totalAmount.toStringAsFixed(2)} EGP',
                            style: TextStyle(
                              color: goldColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Get.toNamed(Routes.HOME),
                              child: const Text('Add Another Item'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: PrimaryButton(
                              label: 'Review Order ☕',
                              onPressed: () => Get.toNamed(Routes.CHECKOUT),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          // Regular Cart
          final cartItems = cartController.cartItems;
          if (cartItems.isEmpty) {
            return EmptyState(
              icon: Icons.shopping_bag_outlined,
              title: 'Your Cart is Empty',
              message:
                  'Discover our premium handcrafted coffee selections and add items to your cart.',
              actionLabel: 'Browse Menu',
              onAction: () => Get.toNamed(Routes.HOME),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  physics: const BouncingScrollPhysics(),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return CafeCard(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: item.product.image.startsWith('assets/')
                                ? Image.asset(
                                    item.product.image,
                                    width: 52,
                                    height: 52,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 52,
                                      height: 52,
                                      color: goldColor.withValues(alpha: 0.2),
                                      child: const Icon(Icons.local_cafe,
                                          size: 24),
                                    ),
                                  )
                                : Image.network(
                                    item.product.image,
                                    width: 52,
                                    height: 52,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 52,
                                      height: 52,
                                      color: goldColor.withValues(alpha: 0.2),
                                      child: const Icon(Icons.local_cafe,
                                          size: 24),
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.product.name,
                                  style: TextStyle(
                                    color: isDark
                                        ? AppColors.darkTextPrimary
                                        : AppColors.lightTextPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '${item.selectedSize.name} • ${item.selectedMilk.name}',
                                  style: TextStyle(
                                    color: isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextSecondary,
                                    fontSize: 11,
                                  ),
                                ),
                                Text(
                                  '${item.totalPrice.toStringAsFixed(2)} EGP',
                                  style: TextStyle(
                                    color: goldColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                    Icons.remove_circle_outline_rounded,
                                    size: 20),
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                                onPressed: () =>
                                    cartController.decrementQuantity(item.id),
                              ),
                              Text(
                                '${item.quantity}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: const Icon(
                                    Icons.add_circle_outline_rounded,
                                    size: 20),
                                color: greenColor,
                                onPressed: () =>
                                    cartController.incrementQuantity(item.id),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Bottom CTA
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCardBg : AppColors.lightCardBg,
                  border: Border(
                    top: BorderSide(
                      color:
                          isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      width: 1.2,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Amount:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                        Text(
                          '${cartController.total.toStringAsFixed(2)} EGP',
                          style: TextStyle(
                              color: goldColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    PrimaryButton(
                      label: 'Proceed to Checkout ☕',
                      onPressed: () => Get.toNamed(Routes.CHECKOUT),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

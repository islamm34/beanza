import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/controllers/cart_controller.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/common/app_app_bar.dart';
import '../../../../core/widgets/common/empty_state.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppAppBar(
        title: 'Shopping Cart',
        actions: [
          Obx(
            () => cartController.cartItems.isNotEmpty
                ? TextButton(
                    onPressed: () => cartController.clearCart(),
                    child: const Text('Clear'),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return EmptyState(
            icon: Icons.shopping_bag_outlined,
            title: 'Your Cart is Empty',
            message: 'Explore our coffee menu and add your favorite drinks!',
            actionLabel: 'Browse Coffee',
            onAction: () => Get.toNamed('/home'),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartController.cartItems[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: isDark
                            ? AppColors.darkSecondaryBg
                            : AppColors.softSand,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              item.product.image,
                              width: 72,
                              height: 72,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 72,
                                height: 72,
                                color: AppColors.softSand,
                                child: const Icon(Icons.local_cafe),
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Size: ${item.selectedSize.name} • ${item.selectedMilk.name}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppColors.getTextMutedColor(
                                          Theme.of(context).brightness,
                                        ),
                                      ),
                                ),
                                if (item.selectedExtras.isNotEmpty)
                                  Text(
                                    'Extras: ${item.selectedExtras.map((e) => e.name).join(', ')}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: AppColors.caramel,
                                          fontSize: 11,
                                        ),
                                  ),
                                const SizedBox(height: 8),
                                Text(
                                  '\$${item.totalPrice.toStringAsFixed(2)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.caramel,
                                      ),
                                ),
                              ],
                            ),
                          ),

                          // Quantity Controls
                          Container(
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkSecondaryBg
                                  : AppColors.lightSecondaryBg,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove, size: 16),
                                  onPressed: () => cartController
                                      .decrementQuantity(item.id),
                                ),
                                Text(
                                  '${item.quantity}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add, size: 16),
                                  onPressed: () => cartController
                                      .incrementQuantity(item.id),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Cart Summary Breakdown Footer
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBg : AppColors.lightCardBg,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildSummaryRow(
                    context,
                    'Subtotal',
                    '\$${cartController.subtotal.toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: 8),
                  _buildSummaryRow(
                    context,
                    'Est. Tax (8%)',
                    '\$${cartController.tax.toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: 8),
                  _buildSummaryRow(
                    context,
                    'Delivery Fee',
                    '\$${cartController.deliveryFee.toStringAsFixed(2)}',
                  ),
                  const Divider(height: 24),
                  _buildSummaryRow(
                    context,
                    'Total Price',
                    '\$${cartController.total.toStringAsFixed(2)}',
                    isTotal: true,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => Get.toNamed('/checkout'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.espressoDark,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Proceed to Checkout',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSummaryRow(BuildContext context, String label, String value,
      {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)
              : Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.getTextMutedColor(
                        Theme.of(context).brightness),
                  ),
        ),
        Text(
          value,
          style: isTotal
              ? Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.caramel,
                  )
              : Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/controllers/cart_controller.dart';
import '../../../../app/controllers/orders_controller.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../order_tracking/presentation/pages/order_tracking_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool _isDelivery = true;
  String _selectedAddress = '123 5th Avenue, Apt 4B, New York, NY';
  String _selectedPayment = 'Brewora Wallet';

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final ordersController = Get.find<OrdersController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Option Toggle (Delivery vs Pickup)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkCardBg
                    : AppColors.lightSecondaryBg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isDelivery = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _isDelivery
                              ? AppColors.espressoDark
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Delivery 🛵',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _isDelivery ? Colors.white : AppColors.getTextColor(Theme.of(context).brightness),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isDelivery = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: !_isDelivery
                              ? AppColors.espressoDark
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Store Pickup ☕',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: !_isDelivery ? Colors.white : AppColors.getTextColor(Theme.of(context).brightness),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Delivery Address Card
            if (_isDelivery) ...[
              Text(
                'Delivery Address',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCardBg : AppColors.lightCardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.darkSecondaryBg : AppColors.softSand,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: AppColors.caramel),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _selectedAddress,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 18),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Payment Method Selection
            Text(
              'Payment Method',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            _buildPaymentOption(
              context,
              title: 'Brewora Wallet (\$45.50)',
              icon: Icons.account_balance_wallet_rounded,
              value: 'Brewora Wallet',
            ),
            _buildPaymentOption(
              context,
              title: 'Credit Card (**** 4242)',
              icon: Icons.credit_card_rounded,
              value: 'Credit Card',
            ),
            _buildPaymentOption(
              context,
              title: 'Apple Pay / Google Pay',
              icon: Icons.contactless_rounded,
              value: 'Digital Wallet',
            ),
            const SizedBox(height: 24),

            // Items Summary
            Text(
              'Order Summary',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBg : AppColors.lightCardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppColors.darkSecondaryBg : AppColors.softSand,
                ),
              ),
              child: Column(
                children: [
                  Obx(
                    () => Column(
                      children: cartController.cartItems.map((item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${item.quantity}x ${item.product.name} (${item.selectedSize.name})',
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                              Text(
                                '\$${item.totalPrice.toStringAsFixed(2)}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Amount', style: TextStyle(fontWeight: FontWeight.bold)),
                      Obx(
                        () => Text(
                          '\$${cartController.total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.caramel,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Place Order Action Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  if (cartController.cartItems.isEmpty) return;

                  final newOrder = ordersController.placeOrder(
                    items: cartController.cartItems,
                    subtotal: cartController.subtotal,
                    tax: cartController.tax,
                    deliveryFee: _isDelivery ? cartController.deliveryFee : 0.0,
                    total: cartController.total,
                    deliveryAddress: _selectedAddress,
                  );

                  Get.off(
                    () => OrderTrackingPage(orderId: newOrder.id),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.espressoDark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Confirm & Place Order',
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
    );
  }

  Widget _buildPaymentOption(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String value,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = _selectedPayment == value;

    return GestureDetector(
      onTap: () => setState(() => _selectedPayment = value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCardBg : AppColors.lightCardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.caramel : (isDark ? AppColors.darkSecondaryBg : AppColors.softSand),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.caramel : AppColors.getTextMutedColor(Theme.of(context).brightness)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: AppColors.caramel),
          ],
        ),
      ),
    );
  }
}

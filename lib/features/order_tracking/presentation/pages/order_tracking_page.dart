import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/controllers/orders_controller.dart';
import '../../../../app/theme/app_colors.dart';

class OrderTrackingPage extends StatelessWidget {
  final String orderId;

  const OrderTrackingPage({this.orderId = 'ORD-1001', Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ordersController = Get.find<OrdersController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final order = ordersController.getOrderById(orderId) ??
        (ordersController.orders.isNotEmpty
            ? ordersController.orders.first
            : null);

    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${order?.id ?? orderId}'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [AppColors.espressoDark, Color(0xFF4A2E20)],
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.caramel.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.coffee_maker_rounded,
                      color: AppColors.caramel,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order?.statusDisplayName ?? 'Preparing your coffee',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Estimated arrival: 15-20 mins',
                          style: TextStyle(
                            color: AppColors.caramel,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Timeline Steps
            Text(
              'Order Status',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildTimelineStep(
              context,
              title: 'Order Received',
              subtitle: 'We have received your coffee order.',
              isCompleted: true,
              isFirst: true,
            ),
            _buildTimelineStep(
              context,
              title: 'Order Confirmed',
              subtitle: 'Store has accepted your order.',
              isCompleted: true,
            ),
            _buildTimelineStep(
              context,
              title: 'Barista Preparing',
              subtitle: 'Grinding beans & steaming milk.',
              isCompleted: true,
              isActive: true,
            ),
            _buildTimelineStep(
              context,
              title: 'Out for Delivery / Pickup',
              subtitle: 'On its way to 5th Avenue, NYC.',
              isCompleted: false,
              isLast: true,
            ),
            const SizedBox(height: 28),

            // Order Details Breakdown
            if (order != null) ...[
              Text(
                'Items Summary',
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
                    color: isDark
                        ? AppColors.darkSecondaryBg
                        : AppColors.softSand,
                  ),
                ),
                child: Column(
                  children: [
                    ...order.items.map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${item.quantity}x ${item.product.name}'),
                              Text(
                                '\$${item.totalPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Amount',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          '\$${order.total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.caramel,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 32),

            // Back to Home Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Get.offAllNamed('/'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.espressoDark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Back to Home',
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

  Widget _buildTimelineStep(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool isCompleted,
    bool isActive = false,
    bool isFirst = false,
    bool isLast = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? AppColors.caramel
                    : (isDark
                        ? AppColors.darkSecondaryBg
                        : AppColors.softSand),
                border: isActive
                    ? Border.all(color: AppColors.espressoDark, width: 3)
                    : null,
              ),
              child: Center(
                child: Icon(
                  isCompleted ? Icons.check : Icons.circle,
                  size: 14,
                  color: isCompleted
                      ? AppColors.espressoDark
                      : AppColors.getTextMutedColor(
                          Theme.of(context).brightness),
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 44,
                color: isCompleted
                    ? AppColors.caramel
                    : (isDark
                        ? AppColors.darkSecondaryBg
                        : AppColors.softSand),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isCompleted
                          ? AppColors.getTextColor(Theme.of(context).brightness)
                          : AppColors.getTextMutedColor(
                              Theme.of(context).brightness),
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.getTextMutedColor(
                          Theme.of(context).brightness),
                    ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }
}

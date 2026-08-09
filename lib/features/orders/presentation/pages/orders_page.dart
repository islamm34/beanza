import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/controllers/orders_controller.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/common/app_app_bar.dart';
import '../../../../core/widgets/common/empty_state.dart';
import '../../../order_tracking/presentation/pages/order_tracking_page.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ordersController = Get.find<OrdersController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const AppAppBar(
        title: 'My Orders',
      ),
      body: Obx(() {
        if (ordersController.orders.isEmpty) {
          return EmptyState(
            icon: Icons.receipt_long_outlined,
            title: 'No Orders Yet',
            message: 'You haven\'t placed any coffee orders yet.',
            actionLabel: 'Order Coffee Now',
            onAction: () => Get.toNamed('/home'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          itemCount: ordersController.orders.length,
          itemBuilder: (context, index) {
            final order = ordersController.orders[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Order #${order.id}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.caramel.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          order.statusDisplayName,
                          style: const TextStyle(
                            color: AppColors.caramel,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Items Summary
                  Text(
                    order.items.isNotEmpty
                        ? order.items.map((i) => '${i.quantity}x ${i.product.name}').join(', ')
                        : 'Brewora Coffee Selection',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.getTextMutedColor(
                              Theme.of(context).brightness),
                        ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),

                  // Footer Total & Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Price',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.getTextMutedColor(
                                      Theme.of(context).brightness),
                                ),
                          ),
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
                      ElevatedButton(
                        onPressed: () => Get.to(
                          () => OrderTrackingPage(orderId: order.id),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.espressoDark,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Track Order',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}

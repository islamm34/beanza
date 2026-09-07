import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/controllers/orders_controller.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/common/app_app_bar.dart';
import '../../../../core/widgets/common/cafe_card.dart';
import '../../../../core/widgets/common/empty_state.dart';
import '../../../order_tracking/presentation/pages/order_tracking_page.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  int _selectedTab = 0; // 0 = Rounds, 1 = All Orders

  @override
  Widget build(BuildContext context) {
    final ordersController = Get.find<OrdersController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldColor = isDark ? AppColors.gold : AppColors.goldLight;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppAppBar(
        title: 'orders_page_title'.tr,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Tabs at Top: "Rounds" & "All Orders"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkCardElevated
                      : AppColors.lightSecondaryBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color:
                        isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedTab = 0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          decoration: BoxDecoration(
                            color: _selectedTab == 0
                                ? goldColor.withValues(
                                    alpha: isDark ? 0.22 : 0.16)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: _selectedTab == 0
                                ? Border.all(color: goldColor, width: 1.2)
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              'table_rounds_tab'.tr,
                              style: TextStyle(
                                color: _selectedTab == 0
                                    ? (isDark
                                        ? AppColors.goldBright
                                        : goldColor)
                                    : (isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextSecondary),
                                fontWeight: _selectedTab == 0
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
                        onTap: () => setState(() => _selectedTab = 1),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          decoration: BoxDecoration(
                            color: _selectedTab == 1
                                ? goldColor.withValues(
                                    alpha: isDark ? 0.22 : 0.16)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: _selectedTab == 1
                                ? Border.all(color: goldColor, width: 1.2)
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              'all_orders_tab'.tr,
                              style: TextStyle(
                                color: _selectedTab == 1
                                    ? (isDark
                                        ? AppColors.goldBright
                                        : goldColor)
                                    : (isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextSecondary),
                                fontWeight: _selectedTab == 1
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

            // 2. Orders / Rounds List
            Expanded(
              child: Obx(() {
                final orders = ordersController.orders;

                if (orders.isEmpty) {
                  return EmptyState(
                    icon: Icons.receipt_long_outlined,
                    title: 'no_orders_yet'.tr,
                    message: 'no_orders_subtitle'.tr,
                    actionLabel: 'order_coffee_now'.tr,
                    onAction: () => Get.toNamed(Routes.HOME),
                  );
                }

                return ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  physics: const BouncingScrollPhysics(),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    final isCompleted =
                        order.status.name == 'delivered' || index > 0;
                    final totalItems =
                        order.items.fold<int>(0, (sum, i) => sum + i.quantity);

                    return CafeCard(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      onTap: () =>
                          Get.to(() => OrderTrackingPage(orderId: order.id)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top Header: Round / Order Reference & Status Badge
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedTab == 0
                                    ? 'round_table_header'.trParams({
                                        'round': '${index + 1}',
                                        'table': '12',
                                      })
                                    : 'order_ref'.trParams({'id': order.id}),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary,
                                ),
                              ),
                              CafeBadge(
                                text: isCompleted
                                    ? 'status_completed'.tr
                                    : 'status_preparing'.tr,
                                isGreen: isCompleted,
                                isGold: !isCompleted,
                                icon: isCompleted
                                    ? Icons.check_circle_rounded
                                    : Icons.hourglass_top_rounded,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Items snippet
                          Text(
                            order.items.isNotEmpty
                                ? order.items
                                    .map((i) =>
                                        '${i.quantity}x ${i.product.localizedName}')
                                    .join(', ')
                                : 'Artisan Coffee',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                              fontSize: 12.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Divider(
                              color: isDark
                                  ? AppColors.darkBorder
                                  : AppColors.lightBorder),
                          const SizedBox(height: 8),

                          // Footer: Total & Item Count & Track Action
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${'items_count'.trParams({'count': '$totalItems'})} • ${order.orderDate.hour}:${order.orderDate.minute.toString().padLeft(2, '0')}',
                                    style: TextStyle(
                                      color: isDark
                                          ? AppColors.darkTextSecondary
                                          : AppColors.lightTextSecondary,
                                      fontSize: 11.5,
                                    ),
                                  ),
                                  Text(
                                    '${order.total.toStringAsFixed(2)} ${'egp'.tr}',
                                    style: TextStyle(
                                      color: goldColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              TextButton.icon(
                                onPressed: () => Get.to(
                                    () => OrderTrackingPage(orderId: order.id)),
                                icon: Icon(Icons.radar_rounded,
                                    size: 16, color: goldColor),
                                label: Text(
                                  'track_live_btn'.tr,
                                  style: TextStyle(
                                      color: goldColor,
                                      fontWeight: FontWeight.bold),
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
            ),

            // 3. Bottom Summary Banner: Total Spent & Beans Earned
            Obx(() {
              final totalSpent = ordersController.orders
                  .fold<double>(0.0, (sum, o) => sum + o.total);
              final beansEarned = (totalSpent * 2).toInt();

              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'total_spent'.tr,
                          style: TextStyle(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                            fontSize: 11.5,
                          ),
                        ),
                        Text(
                          '${totalSpent.toStringAsFixed(2)} ${'egp'.tr}',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color:
                            goldColor.withValues(alpha: isDark ? 0.20 : 0.14),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: goldColor, width: 1.2),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.coffee_rounded,
                              color: goldColor, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'beans_earned_badge'
                                .trParams({'count': '$beansEarned'}),
                            style: TextStyle(
                              color: isDark ? AppColors.goldBright : goldColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

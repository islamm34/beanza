import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/common/cafe_card.dart';
import '../../../order_tracking/presentation/pages/order_tracking_page.dart';

class OrderConfirmationPage extends StatelessWidget {
  final String orderId;
  final double totalAmount;

  const OrderConfirmationPage({
    Key? key,
    required this.orderId,
    required this.totalAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldColor = isDark ? AppColors.gold : AppColors.goldLight;
    final greenColor =
        isDark ? AppColors.primaryGreen : AppColors.primaryGreenLight;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 1. Premium Coffee Celebration Visual
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: greenColor.withValues(alpha: isDark ? 0.18 : 0.12),
                    border: Border.all(color: greenColor, width: 2.5),
                    boxShadow: [
                      BoxShadow(
                        color: greenColor.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.check_circle_rounded,
                      size: 56,
                      color: greenColor,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 2. Round Number Prominently
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: goldColor.withValues(alpha: isDark ? 0.20 : 0.14),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: goldColor, width: 1.2),
                  ),
                  child: Text(
                    'ROUND 1 COMPLETED • الجولة الأولى مكتملة',
                    style: TextStyle(
                      color: isDark ? AppColors.goldBright : goldColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.5,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                Text(
                  'Order Sent to Barista! ☕',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Thank you for ordering at Brewora. Your handcrafted drinks are now being freshly brewed.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),

                // Order Details Summary Card
                CafeCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Order Reference',
                              style: TextStyle(
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                                  fontSize: 13)),
                          Text('#$orderId',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Table Number',
                              style: TextStyle(
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                                  fontSize: 13)),
                          const Text('Table 12',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Estimated Prep',
                              style: TextStyle(
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                                  fontSize: 13)),
                          Text('10 - 15 mins',
                              style: TextStyle(
                                  color: goldColor,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Divider(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Paid / الإجمالي',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary)),
                          Text(
                            '${totalAmount.toStringAsFixed(2)} EGP',
                            style: TextStyle(
                              color: goldColor,
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // 3. Main Action: Start Round 2
                PrimaryButton(
                  label: 'Start Round 2 (Order More Drinks) ☕',
                  onPressed: () => Get.offAllNamed(Routes.HOME),
                ),
                const SizedBox(height: 12),

                // Secondary Action: Track Live Order
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        Get.to(() => OrderTrackingPage(orderId: orderId)),
                    icon: Icon(Icons.radar_rounded, color: goldColor, size: 18),
                    label: Text(
                      'Live Order Tracking',
                      style: TextStyle(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                TextButton.icon(
                  onPressed: () => Get.offAllNamed(Routes.ORDERS),
                  icon: Icon(Icons.history_rounded, size: 16, color: goldColor),
                  label: Text('View Order History',
                      style: TextStyle(
                          color: goldColor, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

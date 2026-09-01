import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/controllers/orders_controller.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/common/app_app_bar.dart';
import '../../../../core/widgets/common/cafe_card.dart';

class OrderTrackingPage extends StatelessWidget {
  final String orderId;

  const OrderTrackingPage({this.orderId = 'ORD-1001', Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ordersController = Get.find<OrdersController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldColor = isDark ? AppColors.gold : AppColors.goldLight;
    final greenColor =
        isDark ? AppColors.primaryGreen : AppColors.primaryGreenLight;

    final order = ordersController.getOrderById(orderId) ??
        (ordersController.orders.isNotEmpty
            ? ordersController.orders.first
            : null);

    final stages = [
      {
        'title': 'Order Received',
        'arabic': 'تم استلام الطلب',
        'status': 'completed'
      },
      {
        'title': 'Barista Assigned',
        'arabic': 'تم تعيين الباريستا',
        'status': 'completed'
      },
      {
        'title': 'Grinding Beans',
        'arabic': 'طحن حبوب القهوة الطازجة',
        'status': 'completed'
      },
      {
        'title': 'Brewing Espresso',
        'arabic': 'استخلاص الإسبريسو الفاخر',
        'status': 'current'
      },
      {
        'title': 'Steaming Milk & Preparing',
        'arabic': 'تبخير الحليب والتحضير',
        'status': 'pending'
      },
      {
        'title': 'Serving at Table',
        'arabic': 'التقديم على الطاولة',
        'status': 'pending'
      },
      {
        'title': 'Delivered & Enjoy',
        'arabic': 'تم التوصيل • بالهناء والشفاء',
        'status': 'pending'
      },
    ];

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppAppBar(
        title: 'Live Order Tracking',
        showCartAction: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Large Circular Preparation Timer with Gold Progress Ring
              Center(
                child: Container(
                  width: 170,
                  height: 170,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 170,
                        height: 170,
                        child: CircularProgressIndicator(
                          value: 0.65,
                          strokeWidth: 9,
                          backgroundColor: isDark
                              ? AppColors.darkCardElevated
                              : AppColors.lightSecondaryBg,
                          valueColor: AlwaysStoppedAnimation<Color>(goldColor),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.coffee_maker_rounded,
                              color: goldColor, size: 28),
                          const SizedBox(height: 6),
                          Text(
                            '06:45',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.lightTextPrimary,
                              letterSpacing: 1.0,
                            ),
                          ),
                          Text(
                            'mins remaining',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Status Headline
              Text(
                'Brewing in Progress ☕',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Order #${order?.id ?? orderId} • Table 12',
                style: TextStyle(
                  fontSize: 13,
                  color: goldColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),

              // 2. Order Status Timeline (7 stages)
              CafeCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: List.generate(stages.length, (index) {
                    final stage = stages[index];
                    final isCompleted = stage['status'] == 'completed';
                    final isCurrent = stage['status'] == 'current';
                    final isLast = index == stages.length - 1;

                    Color dotColor;
                    Widget icon;
                    if (isCompleted) {
                      dotColor = greenColor;
                      icon = const Icon(Icons.check_rounded,
                          color: Colors.white, size: 14);
                    } else if (isCurrent) {
                      dotColor = goldColor;
                      icon = Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      );
                    } else {
                      dotColor = isDark
                          ? const Color(0xFF333333)
                          : const Color(0xFFCCCCCC);
                      icon = const SizedBox.shrink();
                    }

                    return IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: dotColor,
                                  shape: BoxShape.circle,
                                  boxShadow: isCurrent
                                      ? [
                                          BoxShadow(
                                            color: goldColor.withValues(
                                                alpha: 0.5),
                                            blurRadius: 8,
                                          )
                                        ]
                                      : null,
                                ),
                                child: Center(child: icon),
                              ),
                              if (!isLast)
                                Expanded(
                                  child: Container(
                                    width: 2,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    color: isCompleted
                                        ? greenColor.withValues(alpha: 0.6)
                                        : (isDark
                                            ? AppColors.darkBorder
                                            : AppColors.lightBorder),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    stage['title']!,
                                    style: TextStyle(
                                      color: isCurrent
                                          ? (isDark
                                              ? AppColors.goldBright
                                              : goldColor)
                                          : (isCompleted
                                              ? (isDark
                                                  ? AppColors.darkTextPrimary
                                                  : AppColors.lightTextPrimary)
                                              : (isDark
                                                  ? AppColors.darkTextSecondary
                                                  : AppColors
                                                      .lightTextSecondary)),
                                      fontWeight: isCurrent || isCompleted
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      fontSize: 13.5,
                                    ),
                                  ),
                                  Text(
                                    stage['arabic']!,
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
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 20),

              // 3. Assigned Barista Card
              CafeCard(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: goldColor.withValues(alpha: 0.2),
                      child: Icon(Icons.person_rounded,
                          color: goldColor, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Master Barista Youssef',
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.lightTextPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Crafting your specialty brews • خبير القهوة',
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                              fontSize: 11.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: greenColor.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.chat_bubble_outline_rounded,
                            color: greenColor, size: 18),
                      ),
                      onPressed: () {
                        Get.snackbar(
                          'Barista Chat',
                          'Barista Youssef is preparing your order with care.',
                          backgroundColor: isDark
                              ? AppColors.darkCardBg
                              : AppColors.lightCardBg,
                          colorText: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

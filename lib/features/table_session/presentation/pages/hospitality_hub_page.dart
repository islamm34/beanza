import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/controllers/table_session_controller.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/common/app_app_bar.dart';
import '../../../../core/widgets/common/cafe_card.dart';

class HospitalityHubPage extends StatelessWidget {
  const HospitalityHubPage({Key? key}) : super(key: key);

  static void showHub(BuildContext context) {
    Get.to(() => const HospitalityHubPage());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldColor = isDark ? AppColors.gold : AppColors.goldLight;
    final greenColor =
        isDark ? AppColors.primaryGreen : AppColors.primaryGreenLight;

    TableSessionController? tableCtrl;
    if (Get.isRegistered<TableSessionController>()) {
      tableCtrl = Get.find<TableSessionController>();
    }
    final tableNum = tableCtrl?.tableNumber ?? '12';

    final services = [
      {
        'title': 'Call Waiter',
        'arabic': 'استدعاء النادل',
        'icon': Icons.room_service_rounded,
        'color': goldColor
      },
      {
        'title': 'Request Tissues',
        'arabic': 'طلب مناديل',
        'icon': Icons.clean_hands_rounded,
        'color': greenColor
      },
      {
        'title': 'Need Water',
        'arabic': 'طلب ماء نقي',
        'icon': Icons.water_drop_rounded,
        'color': const Color(0xFF29B6F6)
      },
      {
        'title': 'Need Cutlery',
        'arabic': 'طلب أدوات مائدة',
        'icon': Icons.restaurant_rounded,
        'color': goldColor
      },
      {
        'title': 'Coal Change',
        'arabic': 'تبديل الفحم',
        'icon': Icons.fireplace_rounded,
        'color': const Color(0xFFFF7043)
      },
      {
        'title': 'Birthday Surprise',
        'arabic': 'مفاجأة عيد ميلاد',
        'icon': Icons.cake_rounded,
        'color': const Color(0xFFAB47BC)
      },
      {
        'title': 'Call Manager',
        'arabic': 'استدعاء المدير',
        'icon': Icons.support_agent_rounded,
        'color': goldColor
      },
      {
        'title': 'Feedback',
        'arabic': 'تقييم وملاحظات',
        'icon': Icons.rate_review_rounded,
        'color': greenColor
      },
    ];

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppAppBar(
        title: 'Hospitality Hub • Table $tableNum',
        showCartAction: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.15,
                ),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final s = services[index];
                  final iconColor = s['color'] as Color;

                  return CafeCard(
                    padding: const EdgeInsets.all(14),
                    onTap: () {
                      Get.snackbar(
                        'Request Sent',
                        '${s['title']} requested for Table $tableNum. Staff on the way!',
                        backgroundColor: isDark
                            ? AppColors.darkCardBg
                            : AppColors.lightCardBg,
                        colorText: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: iconColor.withValues(
                                alpha: isDark ? 0.20 : 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            s['icon'] as IconData,
                            color: iconColor,
                            size: 26,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          s['title'] as String,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          s['arabic'] as String,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Premium Gold/Brown "Request Bill" CTA at Bottom
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.snackbar(
                      'Bill Requested',
                      'The bill for Table $tableNum is on its way.',
                      backgroundColor:
                          isDark ? AppColors.darkCardBg : AppColors.lightCardBg,
                      colorText: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    );
                  },
                  icon: const Icon(Icons.receipt_long_rounded,
                      color: Colors.white, size: 20),
                  label: const Text(
                    'Request Table Bill • طلب الحساب',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: goldColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
        'key': 'service_call_waiter',
        'icon': Icons.room_service_rounded,
        'color': goldColor
      },
      {
        'key': 'service_request_tissues',
        'icon': Icons.clean_hands_rounded,
        'color': greenColor
      },
      {
        'key': 'service_need_water',
        'icon': Icons.water_drop_rounded,
        'color': const Color(0xFF29B6F6)
      },
      {
        'key': 'service_need_cutlery',
        'icon': Icons.restaurant_rounded,
        'color': goldColor
      },
      {
        'key': 'service_coal_change',
        'icon': Icons.fireplace_rounded,
        'color': const Color(0xFFFF7043)
      },
      {
        'key': 'service_birthday_surprise',
        'icon': Icons.cake_rounded,
        'color': const Color(0xFFAB47BC)
      },
      {
        'key': 'service_call_manager',
        'icon': Icons.support_agent_rounded,
        'color': goldColor
      },
      {
        'key': 'service_feedback',
        'icon': Icons.rate_review_rounded,
        'color': greenColor
      },
    ];

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppAppBar(
        title: 'hospitality_hub_table_title'.trParams({'table': tableNum}),
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
                  final serviceKey = s['key'] as String;
                  final serviceTitle = serviceKey.tr;

                  return CafeCard(
                    padding: const EdgeInsets.all(14),
                    onTap: () {
                      Get.snackbar(
                        'service_requested_title'.tr,
                        'service_requested_for_table'.trParams({
                          'service': serviceTitle,
                          'table': tableNum,
                        }),
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
                        const SizedBox(height: 10),
                        Text(
                          serviceTitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
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
                      'bill_requested_title'.tr,
                      'bill_requested_for_table'.trParams({'table': tableNum}),
                      backgroundColor:
                          isDark ? AppColors.darkCardBg : AppColors.lightCardBg,
                      colorText: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    );
                  },
                  icon: const Icon(Icons.receipt_long_rounded,
                      color: Colors.white, size: 20),
                  label: Text(
                    'request_table_bill_btn'.tr,
                    style: const TextStyle(
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

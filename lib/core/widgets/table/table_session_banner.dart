import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glassy/glassy_card.dart';
import 'package:glassy/glassy_config.dart';

import '../../../app/controllers/table_session_controller.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';

class TableSessionBanner extends StatelessWidget {
  const TableSessionBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<TableSessionController>()) {
      return const SizedBox.shrink();
    }

    final controller = Get.find<TableSessionController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      if (!controller.hasActiveSession) {
        return const SizedBox.shrink();
      }

      final tableNum = controller.tableNumber;
      final myName = controller.currentParticipant.value?.displayName ?? 'You';
      final pCount = controller.participantCount;

      return Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: GlassyCard(
          config: GlassyConfig(
            radius: 16,
            backgroundColor:
                isDark ? AppColors.darkCardBg : AppColors.espressoDark,
            backgroundOpacity: isDark ? 0.75 : 0.92,
            borderColor: AppColors.caramel,
            borderOpacity: 0.35,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.caramel.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.table_restaurant_rounded,
                    color: AppColors.caramel,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Table $tableNum • $myName',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$pCount Participants at Table',
                        style: const TextStyle(
                          color: AppColors.caramel,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => Get.toNamed(Routes.TABLE_OVERVIEW),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.caramel,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Overview',
                      style: TextStyle(
                        color: AppColors.espressoDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

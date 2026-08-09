import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/controllers/notifications_controller.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/common/app_app_bar.dart';
import '../../../../core/widgets/common/empty_state.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notificationsController = Get.find<NotificationsController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppAppBar(
        title: 'Notifications',
        actions: [
          Obx(
            () => notificationsController.notifications.isNotEmpty
                ? TextButton(
                    onPressed: () => notificationsController.clearAll(),
                    child: const Text('Clear All'),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      body: Obx(() {
        if (notificationsController.notifications.isEmpty) {
          return EmptyState(
            icon: Icons.notifications_off_outlined,
            title: 'No Notifications',
            message: 'You have no new notifications at this time.',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          itemCount: notificationsController.notifications.length,
          itemBuilder: (context, index) {
            final notif = notificationsController.notifications[index];
            return GestureDetector(
              onTap: () => notificationsController.markAsRead(notif.id),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: notif.isRead
                      ? (isDark ? AppColors.darkCardBg : AppColors.lightCardBg)
                      : (isDark
                          ? AppColors.darkSecondaryBg
                          : AppColors.cream),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: notif.isRead
                        ? (isDark
                            ? AppColors.darkSecondaryBg
                            : AppColors.softSand)
                        : AppColors.caramel,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.caramel.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_rounded,
                        color: AppColors.caramel,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                notif.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              if (!notif.isRead)
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: AppColors.caramel,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            notif.body,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppColors.getTextMutedColor(
                                      Theme.of(context).brightness),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

import 'package:get/get.dart';
import '../../core/services/notification_service.dart';
import '../../features/notifications/data/models/notification_model.dart';
import '../../features/notifications/domain/entities/notification.dart';

class NotificationsController extends GetxController {
  final notifications = <NotificationModel>[
    NotificationModel(
      id: 1,
      title: 'Order Confirmed ☕',
      body: 'Your order #ORD-8472 is being prepared by our barista.',
      payload: '/orders',
      type: NotificationType.order,
      createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
      isRead: false,
    ),
    NotificationModel(
      id: 2,
      title: 'Double Points Friday! 🎁',
      body: 'Earn 2x reward points on all specialty drinks today.',
      payload: '/rewards',
      type: NotificationType.promotion,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      isRead: false,
    ),
  ].obs;

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  Future<void> triggerNotification({
    required String title,
    required String body,
    String? payload,
    NotificationType type = NotificationType.general,
  }) async {
    final notificationId = DateTime.now().millisecondsSinceEpoch % 100000;

    final newNotification = NotificationModel(
      id: notificationId,
      title: title,
      body: body,
      payload: payload,
      type: type,
      createdAt: DateTime.now(),
      isRead: false,
    );

    notifications.insert(0, newNotification);

    // Trigger local device notification if NotificationService is registered
    if (Get.isRegistered<NotificationService>()) {
      await Get.find<NotificationService>().showNotification(
        id: notificationId,
        title: title,
        body: body,
        payload: payload,
      );
    }
  }

  void markAsRead(int id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index >= 0) {
      notifications[index].isRead = true;
      notifications.refresh();
    }
  }

  void markAllAsRead() {
    for (var n in notifications) {
      n.isRead = true;
    }
    notifications.refresh();
  }

  void clearAll() {
    notifications.clear();
  }
}

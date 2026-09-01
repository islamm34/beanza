import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:beanza/app/controllers/notifications_controller.dart';
import 'package:beanza/features/notifications/domain/entities/notification.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NotificationsController Unit Tests', () {
    late NotificationsController notificationsController;

    setUp(() {
      Get.reset();
      notificationsController = Get.put(NotificationsController());
    });

    test('initializes with default notifications', () {
      expect(notificationsController.notifications, isNotEmpty);
      expect(notificationsController.unreadCount, 2);
    });

    test('marks notification as read', () {
      final firstId = notificationsController.notifications.first.id;
      notificationsController.markAsRead(firstId);

      expect(notificationsController.notifications.first.isRead, isTrue);
      expect(notificationsController.unreadCount, 1);
    });

    test('marks all notifications as read', () {
      notificationsController.markAllAsRead();
      expect(notificationsController.unreadCount, 0);
    });

    test('clears all notifications', () {
      notificationsController.clearAll();
      expect(notificationsController.notifications, isEmpty);
      expect(notificationsController.unreadCount, 0);
    });

    test('triggers in-app notification', () async {
      final initialCount = notificationsController.notifications.length;
      await notificationsController.triggerNotification(
        title: 'Test Notification ☕',
        body: 'Test Body Content',
        payload: '/orders',
        type: NotificationType.order,
      );

      expect(notificationsController.notifications.length, initialCount + 1);
      expect(notificationsController.notifications.first.title,
          'Test Notification ☕');
    });
  });
}

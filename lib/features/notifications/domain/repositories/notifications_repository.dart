import '../entities/notifications_entity.dart';

abstract class NotificationsRepository {
  Future<List<NotificationEntity>> getNotifications();
  Future<void> markAsRead(String notificationId);
  Future<void> deleteNotification(String notificationId);
  Future<void> clearAllNotifications();
}

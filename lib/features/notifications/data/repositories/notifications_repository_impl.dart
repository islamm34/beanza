import 'package:beanza/features/notifications/domain/repositories/notifications_repository.dart';

import '../../domain/entities/notifications_entity.dart';
import '../datasources/notifications_remote_data_source.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource remoteDataSource;

  NotificationsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    try {
      final notifications = await remoteDataSource.getNotifications();
      return notifications
          .map(
            (notif) => NotificationEntity(
              id: notif['id'] as String? ?? '',
              title: notif['title'] as String? ?? '',
              message: notif['message'] as String? ?? '',
              type: notif['type'] as String? ?? 'system',
              imageUrl: notif['imageUrl'] as String?,
              isRead: notif['isRead'] as bool? ?? false,
              timestamp: notif['timestamp'] as String? ?? '',
              data: notif['data'] as Map<String, dynamic>?,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get notifications: $e');
    }
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    try {
      await remoteDataSource.markAsRead(notificationId);
    } catch (e) {
      throw Exception('Failed to mark as read: $e');
    }
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    try {
      await remoteDataSource.deleteNotification(notificationId);
    } catch (e) {
      throw Exception('Failed to delete notification: $e');
    }
  }

  @override
  Future<void> clearAllNotifications() async {
    try {
      await remoteDataSource.clearAllNotifications();
    } catch (e) {
      throw Exception('Failed to clear notifications: $e');
    }
  }
}

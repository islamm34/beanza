import '../entities/notifications_entity.dart';
import '../repositories/notifications_repository.dart';

class GetNotificationsUsecase {
  final NotificationsRepository repository;

  GetNotificationsUsecase({required this.repository});

  Future<List<NotificationEntity>> call() async {
    return await repository.getNotifications();
  }
}

class MarkAsReadUsecase {
  final NotificationsRepository repository;

  MarkAsReadUsecase({required this.repository});

  Future<void> call(String notificationId) async {
    return await repository.markAsRead(notificationId);
  }
}

class DeleteNotificationUsecase {
  final NotificationsRepository repository;

  DeleteNotificationUsecase({required this.repository});

  Future<void> call(String notificationId) async {
    return await repository.deleteNotification(notificationId);
  }
}

class ClearAllNotificationsUsecase {
  final NotificationsRepository repository;

  ClearAllNotificationsUsecase({required this.repository});

  Future<void> call() async {
    return await repository.clearAllNotifications();
  }
}

enum NotificationType { order, promotion, reward, general, system }

class NotificationEntity {
  final int id;
  final String title;
  final String body;
  final String? payload;
  final NotificationType type;
  final DateTime createdAt;
  bool isRead;

  NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    this.payload,
    this.type = NotificationType.general,
    required this.createdAt,
    this.isRead = false,
  });

  String get message => body;
}

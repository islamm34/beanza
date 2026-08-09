class NotificationEntity {
  final String id;
  final String title;
  final String message;
  final String type;
  final String? imageUrl;
  final bool isRead;
  final String timestamp;
  final Map<String, dynamic>? data;

  NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.imageUrl,
    required this.isRead,
    required this.timestamp,
    this.data,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          message == other.message &&
          type == other.type &&
          imageUrl == other.imageUrl &&
          isRead == other.isRead &&
          timestamp == other.timestamp &&
          data == other.data;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      message.hashCode ^
      type.hashCode ^
      imageUrl.hashCode ^
      isRead.hashCode ^
      timestamp.hashCode ^
      data.hashCode;
}

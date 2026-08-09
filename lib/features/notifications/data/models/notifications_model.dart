class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type; // order, promotion, system
  final String? imageUrl;
  final bool isRead;
  final String timestamp;
  final Map<String, dynamic>? data;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.imageUrl,
    required this.isRead,
    required this.timestamp,
    this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      type: json['type'] as String? ?? 'system',
      imageUrl: json['imageUrl'] as String?,
      isRead: json['isRead'] as bool? ?? false,
      timestamp: json['timestamp'] as String? ?? '',
      data: json['data'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'message': message,
    'type': type,
    'imageUrl': imageUrl,
    'isRead': isRead,
    'timestamp': timestamp,
    'data': data,
  };
}

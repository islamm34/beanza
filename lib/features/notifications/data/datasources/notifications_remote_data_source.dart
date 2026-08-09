abstract class NotificationsRemoteDataSource {
  /// Gets notifications
  Future<List<Map<String, dynamic>>> getNotifications();

  /// Marks notification as read
  Future<void> markAsRead(String notificationId);

  /// Deletes notification
  Future<void> deleteNotification(String notificationId);

  /// Clears all notifications
  Future<void> clearAllNotifications();
}

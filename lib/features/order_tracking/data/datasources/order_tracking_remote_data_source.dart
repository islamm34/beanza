abstract class OrderTrackingRemoteDataSource {
  /// Gets order tracking updates
  Future<Map<String, dynamic>> trackOrder(String orderId);

  /// Gets order timeline/status history
  Future<List<Map<String, dynamic>>> getOrderTimeline(String orderId);

  /// Gets delivery person details
  Future<Map<String, dynamic>> getDeliveryPersonDetails(String orderId);
}

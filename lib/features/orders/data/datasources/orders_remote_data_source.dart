abstract class OrdersRemoteDataSource {
  /// Gets all user orders
  Future<List<Map<String, dynamic>>> getOrders({String? status});

  /// Gets order details
  Future<Map<String, dynamic>> getOrderDetails(String orderId);

  /// Cancels order
  Future<void> cancelOrder(String orderId);

  /// Reorders previous order
  Future<Map<String, dynamic>> reorder(String orderId);
}

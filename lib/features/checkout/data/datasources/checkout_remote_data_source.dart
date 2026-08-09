abstract class CheckoutRemoteDataSource {
  /// Gets saved addresses
  Future<List<Map<String, dynamic>>> getSavedAddresses();

  /// Adds new address
  Future<Map<String, dynamic>> addAddress(Map<String, dynamic> address);

  /// Gets payment methods
  Future<List<Map<String, dynamic>>> getPaymentMethods();

  /// Creates order
  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> orderData);

  /// Applies coupon code
  Future<Map<String, dynamic>> applyCoupon(String couponCode);
}

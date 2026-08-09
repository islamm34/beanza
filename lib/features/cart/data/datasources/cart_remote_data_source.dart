abstract class CartRemoteDataSource {
  /// Gets cart items from server
  Future<List<Map<String, dynamic>>> getCartItems();

  /// Adds item to cart
  Future<void> addToCart(String productId, Map<String, dynamic> item);

  /// Updates cart item
  Future<void> updateCartItem(String itemId, Map<String, dynamic> updates);

  /// Removes item from cart
  Future<void> removeFromCart(String itemId);

  /// Clears entire cart
  Future<void> clearCart();
}

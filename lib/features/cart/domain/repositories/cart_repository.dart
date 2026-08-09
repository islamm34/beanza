import '../entities/cart_entity.dart';

abstract class CartRepository {
  Future<CartSummaryEntity> getCartItems();

  Future<void> addToCart(String productId, Map<String, dynamic> item);

  Future<void> updateCartItem(String itemId, Map<String, dynamic> updates);

  Future<void> removeFromCart(String itemId);

  Future<void> clearCart();
}

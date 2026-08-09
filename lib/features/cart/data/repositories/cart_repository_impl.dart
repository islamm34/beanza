import '../../domain/entities/cart_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_remote_data_source.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CartSummaryEntity> getCartItems() async {
    try {
      final items = await remoteDataSource.getCartItems();
      double subtotal = 0;
      final cartItems = <CartItemEntity>[];

      for (var item in items) {
        final cartItem = CartItemEntity(
          id: item['id'] as String? ?? '',
          productId: item['productId'] as String? ?? '',
          productName: item['productName'] as String? ?? '',
          price: (item['price'] as num?)?.toDouble() ?? 0.0,
          quantity: item['quantity'] as int? ?? 1,
          selectedSize: item['selectedSize'] as String? ?? '',
          customizations: List<String>.from(
            item['customizations'] as List<dynamic>? ?? [],
          ),
          imageUrl: item['imageUrl'] as String? ?? '',
        );
        cartItems.add(cartItem);
        subtotal += cartItem.totalPrice;
      }

      final tax = subtotal * 0.1;
      final deliveryFee = 2.99;
      const discount = 0.0;
      final total = subtotal + tax + deliveryFee - discount;

      return CartSummaryEntity(
        items: cartItems,
        subtotal: subtotal,
        tax: tax,
        deliveryFee: deliveryFee,
        discount: discount,
        total: total,
      );
    } catch (e) {
      throw Exception('Failed to get cart items: $e');
    }
  }

  @override
  Future<void> addToCart(String productId, Map<String, dynamic> item) async {
    try {
      await remoteDataSource.addToCart(productId, item);
    } catch (e) {
      throw Exception('Failed to add to cart: $e');
    }
  }

  @override
  Future<void> updateCartItem(
    String itemId,
    Map<String, dynamic> updates,
  ) async {
    try {
      await remoteDataSource.updateCartItem(itemId, updates);
    } catch (e) {
      throw Exception('Failed to update cart item: $e');
    }
  }

  @override
  Future<void> removeFromCart(String itemId) async {
    try {
      await remoteDataSource.removeFromCart(itemId);
    } catch (e) {
      throw Exception('Failed to remove from cart: $e');
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      await remoteDataSource.clearCart();
    } catch (e) {
      throw Exception('Failed to clear cart: $e');
    }
  }
}

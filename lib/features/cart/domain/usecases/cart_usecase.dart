import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

class GetCartItemsUsecase {
  final CartRepository repository;

  GetCartItemsUsecase({required this.repository});

  Future<CartSummaryEntity> call() async {
    return await repository.getCartItems();
  }
}

class AddToCartUsecase {
  final CartRepository repository;

  AddToCartUsecase({required this.repository});

  Future<void> call(String productId, Map<String, dynamic> item) async {
    return await repository.addToCart(productId, item);
  }
}

class UpdateCartItemUsecase {
  final CartRepository repository;

  UpdateCartItemUsecase({required this.repository});

  Future<void> call(String itemId, Map<String, dynamic> updates) async {
    return await repository.updateCartItem(itemId, updates);
  }
}

class RemoveFromCartUsecase {
  final CartRepository repository;

  RemoveFromCartUsecase({required this.repository});

  Future<void> call(String itemId) async {
    return await repository.removeFromCart(itemId);
  }
}

class ClearCartUsecase {
  final CartRepository repository;

  ClearCartUsecase({required this.repository});

  Future<void> call() async {
    return await repository.clearCart();
  }
}

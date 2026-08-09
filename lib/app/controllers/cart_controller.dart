import 'package:get/get.dart';
import '../../core/models/cart_item_model.dart';
import '../../core/models/product_model.dart';

class CartController extends GetxController {
  final cartItems = <CartItem>[].obs;

  int get itemCount => cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get tax => subtotal * 0.08;

  double get deliveryFee => cartItems.isEmpty ? 0.0 : 2.50;

  double get total => subtotal + tax + deliveryFee;

  void addToCart({
    required Product product,
    required ProductSize size,
    required MilkOption milk,
    List<Extra> extras = const [],
    int quantity = 1,
  }) {
    final existingIndex = cartItems.indexWhere(
      (item) =>
          item.product.id == product.id &&
          item.selectedSize.name == size.name &&
          item.selectedMilk.name == milk.name &&
          _areExtrasEqual(item.selectedExtras, extras),
    );

    if (existingIndex >= 0) {
      cartItems[existingIndex].quantity += quantity;
      cartItems.refresh();
    } else {
      final newItem = CartItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        product: product,
        selectedSize: size,
        selectedMilk: milk,
        selectedExtras: List.from(extras),
        quantity: quantity,
      );
      cartItems.add(newItem);
    }
  }

  void incrementQuantity(String id) {
    final index = cartItems.indexWhere((item) => item.id == id);
    if (index >= 0) {
      cartItems[index].quantity++;
      cartItems.refresh();
    }
  }

  void decrementQuantity(String id) {
    final index = cartItems.indexWhere((item) => item.id == id);
    if (index >= 0) {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
        cartItems.refresh();
      } else {
        removeFromCart(id);
      }
    }
  }

  void removeFromCart(String id) {
    cartItems.removeWhere((item) => item.id == id);
  }

  void clearCart() {
    cartItems.clear();
  }

  bool _areExtrasEqual(List<Extra> list1, List<Extra> list2) {
    if (list1.length != list2.length) return false;
    final names1 = list1.map((e) => e.name).toList()..sort();
    final names2 = list2.map((e) => e.name).toList()..sort();
    for (int i = 0; i < names1.length; i++) {
      if (names1[i] != names2[i]) return false;
    }
    return true;
  }
}

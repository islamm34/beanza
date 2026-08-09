import 'product_model.dart';

class CartItem {
  final String id;
  final Product product;
  final ProductSize selectedSize;
  final MilkOption selectedMilk;
  final List<Extra> selectedExtras;
  int quantity;

  CartItem({
    required this.id,
    required this.product,
    required this.selectedSize,
    required this.selectedMilk,
    this.selectedExtras = const [],
    this.quantity = 1,
  });

  double get unitPrice {
    double base = product.basePrice * selectedSize.priceMultiplier;
    base += selectedMilk.additionalPrice;
    for (var extra in selectedExtras) {
      base += extra.price;
    }
    return base;
  }

  double get totalPrice => unitPrice * quantity;
}

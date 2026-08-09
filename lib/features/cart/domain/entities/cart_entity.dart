class CartItemEntity {
  final String id;
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String selectedSize;
  final List<String> customizations;
  final String imageUrl;

  CartItemEntity({
    required this.id,
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.selectedSize,
    required this.customizations,
    required this.imageUrl,
  });

  double get totalPrice => price * quantity;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItemEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          productId == other.productId &&
          productName == other.productName &&
          price == other.price &&
          quantity == other.quantity &&
          selectedSize == other.selectedSize &&
          customizations == other.customizations &&
          imageUrl == other.imageUrl;

  @override
  int get hashCode =>
      id.hashCode ^
      productId.hashCode ^
      productName.hashCode ^
      price.hashCode ^
      quantity.hashCode ^
      selectedSize.hashCode ^
      customizations.hashCode ^
      imageUrl.hashCode;
}

class CartSummaryEntity {
  final List<CartItemEntity> items;
  final double subtotal;
  final double tax;
  final double deliveryFee;
  final double discount;
  final double total;

  CartSummaryEntity({
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.deliveryFee,
    required this.discount,
    required this.total,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartSummaryEntity &&
          runtimeType == other.runtimeType &&
          items == other.items &&
          subtotal == other.subtotal &&
          tax == other.tax &&
          deliveryFee == other.deliveryFee &&
          discount == other.discount &&
          total == other.total;

  @override
  int get hashCode =>
      items.hashCode ^
      subtotal.hashCode ^
      tax.hashCode ^
      deliveryFee.hashCode ^
      discount.hashCode ^
      total.hashCode;
}

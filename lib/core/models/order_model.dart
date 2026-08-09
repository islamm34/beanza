import 'cart_item_model.dart';

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  ready,
  completed,
  cancelled,
}

class Order {
  final String id;
  final List<CartItem> items;
  final double subtotal;
  final double tax;
  final double deliveryFee;
  final double discount;
  final double total;
  final String deliveryAddress;
  final DateTime orderDate;
  OrderStatus status;

  Order({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.deliveryFee,
    required this.discount,
    required this.total,
    required this.deliveryAddress,
    required this.orderDate,
    this.status = OrderStatus.pending,
  });

  String get statusDisplayName {
    switch (status) {
      case OrderStatus.pending:
        return 'Order Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.preparing:
        return 'Preparing your coffee';
      case OrderStatus.ready:
        return 'Ready for Pickup / Delivery';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}

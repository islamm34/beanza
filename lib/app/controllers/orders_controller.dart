import 'package:get/get.dart';
import '../../core/models/cart_item_model.dart';
import '../../core/models/order_model.dart';
import '../../features/notifications/domain/entities/notification.dart';
import 'cart_controller.dart';
import 'notifications_controller.dart';

class OrdersController extends GetxController {
  final orders = <Order>[].obs;

  Order placeOrder({
    required List<CartItem> items,
    required double subtotal,
    required double tax,
    required double deliveryFee,
    required double total,
    required String deliveryAddress,
  }) {
    final newOrder = Order(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      items: List.from(items),
      subtotal: subtotal,
      tax: tax,
      deliveryFee: deliveryFee,
      discount: 0.0,
      total: total,
      deliveryAddress: deliveryAddress,
      orderDate: DateTime.now(),
      status: OrderStatus.confirmed,
    );

    orders.insert(0, newOrder);

    // Clear cart after successful order placement
    if (Get.isRegistered<CartController>()) {
      Get.find<CartController>().clearCart();
    }

    // Trigger local order notification
    if (Get.isRegistered<NotificationsController>()) {
      Get.find<NotificationsController>().triggerNotification(
        title: 'Order Confirmed ☕',
        body:
            'Your Brewora order #${newOrder.id} has been successfully placed!',
        payload: '/orders',
        type: NotificationType.order,
      );
    }

    return newOrder;
  }

  Order? getOrderById(String id) {
    return orders.firstWhereOrNull((o) => o.id == id);
  }
}

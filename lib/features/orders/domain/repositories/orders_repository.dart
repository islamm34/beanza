import '../entities/orders_entity.dart';

abstract class OrdersRepository {
  Future<List<OrderEntity>> getOrders({String? status});
  Future<OrderEntity> getOrderDetails(String orderId);
  Future<void> cancelOrder(String orderId);
  Future<OrderEntity> reorder(String orderId);
}

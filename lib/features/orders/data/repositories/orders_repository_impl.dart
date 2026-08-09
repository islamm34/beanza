import '../../domain/entities/orders_entity.dart';
import '../../domain/repositories/orders_repository.dart';
import '../datasources/orders_remote_data_source.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource remoteDataSource;

  OrdersRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<OrderEntity>> getOrders({String? status}) async {
    try {
      final orders = await remoteDataSource.getOrders(status: status);
      return orders
          .map(
            (order) => OrderEntity(
              id: order['id'] as String? ?? '',
              status: order['status'] as String? ?? 'pending',
              total: (order['total'] as num?)?.toDouble() ?? 0.0,
              cafeName: order['cafeName'] as String? ?? '',
              cafeImage: order['cafeImage'] as String? ?? '',
              items: List<Map<String, dynamic>>.from(
                order['items'] as List<dynamic>? ?? [],
              ),
              deliveryAddress: order['deliveryAddress'] as String? ?? '',
              createdAt: order['createdAt'] as String? ?? '',
              deliveredAt: order['deliveredAt'] as String?,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get orders: $e');
    }
  }

  @override
  Future<OrderEntity> getOrderDetails(String orderId) async {
    try {
      final order = await remoteDataSource.getOrderDetails(orderId);
      return OrderEntity(
        id: order['id'] as String? ?? '',
        status: order['status'] as String? ?? 'pending',
        total: (order['total'] as num?)?.toDouble() ?? 0.0,
        cafeName: order['cafeName'] as String? ?? '',
        cafeImage: order['cafeImage'] as String? ?? '',
        items: List<Map<String, dynamic>>.from(
          order['items'] as List<dynamic>? ?? [],
        ),
        deliveryAddress: order['deliveryAddress'] as String? ?? '',
        createdAt: order['createdAt'] as String? ?? '',
        deliveredAt: order['deliveredAt'] as String?,
      );
    } catch (e) {
      throw Exception('Failed to get order details: $e');
    }
  }

  @override
  Future<void> cancelOrder(String orderId) async {
    try {
      await remoteDataSource.cancelOrder(orderId);
    } catch (e) {
      throw Exception('Failed to cancel order: $e');
    }
  }

  @override
  Future<OrderEntity> reorder(String orderId) async {
    try {
      final result = await remoteDataSource.reorder(orderId);
      return OrderEntity(
        id: result['id'] as String? ?? '',
        status: result['status'] as String? ?? 'pending',
        total: (result['total'] as num?)?.toDouble() ?? 0.0,
        cafeName: result['cafeName'] as String? ?? '',
        cafeImage: result['cafeImage'] as String? ?? '',
        items: List<Map<String, dynamic>>.from(
          result['items'] as List<dynamic>? ?? [],
        ),
        deliveryAddress: result['deliveryAddress'] as String? ?? '',
        createdAt: result['createdAt'] as String? ?? '',
        deliveredAt: result['deliveredAt'] as String?,
      );
    } catch (e) {
      throw Exception('Failed to reorder: $e');
    }
  }
}

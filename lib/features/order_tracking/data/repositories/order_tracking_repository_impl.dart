import '../../domain/entities/order_tracking_entity.dart';
import '../../domain/repositories/order_tracking_repository.dart';
import '../datasources/order_tracking_remote_data_source.dart';

class OrderTrackingRepositoryImpl implements OrderTrackingRepository {
  final OrderTrackingRemoteDataSource remoteDataSource;

  OrderTrackingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<OrderTrackingEntity> trackOrder(String orderId) async {
    try {
      final data = await remoteDataSource.trackOrder(orderId);
      return OrderTrackingEntity(
        orderId: data['orderId'] as String? ?? '',
        status: data['status'] as String? ?? 'pending',
        latitude: (data['latitude'] as num?)?.toDouble() ?? 0.0,
        longitude: (data['longitude'] as num?)?.toDouble() ?? 0.0,
        estimatedDelivery: data['estimatedDelivery'] as String? ?? '',
        deliveryPersonName: data['deliveryPersonName'] as String?,
        deliveryPersonImage: data['deliveryPersonImage'] as String?,
        deliveryPersonPhone: data['deliveryPersonPhone'] as String?,
      );
    } catch (e) {
      throw Exception('Failed to track order: $e');
    }
  }

  @override
  Future<List<OrderTimelineEntity>> getOrderTimeline(String orderId) async {
    try {
      final timeline = await remoteDataSource.getOrderTimeline(orderId);
      return timeline
          .map(
            (item) => OrderTimelineEntity(
              status: item['status'] as String? ?? '',
              timestamp: item['timestamp'] as String? ?? '',
              message: item['message'] as String? ?? '',
              isCompleted: item['isCompleted'] as bool? ?? false,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get order timeline: $e');
    }
  }
}

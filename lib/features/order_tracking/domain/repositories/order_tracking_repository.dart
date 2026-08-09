import '../entities/order_tracking_entity.dart';

abstract class OrderTrackingRepository {
  Future<OrderTrackingEntity> trackOrder(String orderId);
  Future<List<OrderTimelineEntity>> getOrderTimeline(String orderId);
}

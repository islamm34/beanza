import '../entities/order_tracking_entity.dart';
import '../repositories/order_tracking_repository.dart';

class TrackOrderUsecase {
  final OrderTrackingRepository repository;

  TrackOrderUsecase({required this.repository});

  Future<OrderTrackingEntity> call(String orderId) async {
    return await repository.trackOrder(orderId);
  }
}

class GetOrderTimelineUsecase {
  final OrderTrackingRepository repository;

  GetOrderTimelineUsecase({required this.repository});

  Future<List<OrderTimelineEntity>> call(String orderId) async {
    return await repository.getOrderTimeline(orderId);
  }
}

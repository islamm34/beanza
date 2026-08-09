class OrderTrackingEntity {
  final String orderId;
  final String status;
  final double latitude;
  final double longitude;
  final String estimatedDelivery;
  final String? deliveryPersonName;
  final String? deliveryPersonImage;
  final String? deliveryPersonPhone;

  OrderTrackingEntity({
    required this.orderId,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.estimatedDelivery,
    this.deliveryPersonName,
    this.deliveryPersonImage,
    this.deliveryPersonPhone,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderTrackingEntity &&
          runtimeType == other.runtimeType &&
          orderId == other.orderId &&
          status == other.status &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          estimatedDelivery == other.estimatedDelivery &&
          deliveryPersonName == other.deliveryPersonName &&
          deliveryPersonImage == other.deliveryPersonImage &&
          deliveryPersonPhone == other.deliveryPersonPhone;

  @override
  int get hashCode =>
      orderId.hashCode ^
      status.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      estimatedDelivery.hashCode ^
      deliveryPersonName.hashCode ^
      deliveryPersonImage.hashCode ^
      deliveryPersonPhone.hashCode;
}

class OrderTimelineEntity {
  final String status;
  final String timestamp;
  final String message;
  final bool isCompleted;

  OrderTimelineEntity({
    required this.status,
    required this.timestamp,
    required this.message,
    required this.isCompleted,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderTimelineEntity &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          timestamp == other.timestamp &&
          message == other.message &&
          isCompleted == other.isCompleted;

  @override
  int get hashCode =>
      status.hashCode ^ timestamp.hashCode ^ message.hashCode ^ isCompleted.hashCode;
}

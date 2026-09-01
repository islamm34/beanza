class OrderTrackingModel {
  final String orderId;
  final String status;
  final double latitude;
  final double longitude;
  final String estimatedDelivery;
  final String? deliveryPersonName;
  final String? deliveryPersonImage;
  final String? deliveryPersonPhone;

  OrderTrackingModel({
    required this.orderId,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.estimatedDelivery,
    this.deliveryPersonName,
    this.deliveryPersonImage,
    this.deliveryPersonPhone,
  });

  factory OrderTrackingModel.fromJson(Map<String, dynamic> json) {
    return OrderTrackingModel(
      orderId: json['orderId'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      estimatedDelivery: json['estimatedDelivery'] as String? ?? '',
      deliveryPersonName: json['deliveryPersonName'] as String?,
      deliveryPersonImage: json['deliveryPersonImage'] as String?,
      deliveryPersonPhone: json['deliveryPersonPhone'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'orderId': orderId,
        'status': status,
        'latitude': latitude,
        'longitude': longitude,
        'estimatedDelivery': estimatedDelivery,
        'deliveryPersonName': deliveryPersonName,
        'deliveryPersonImage': deliveryPersonImage,
        'deliveryPersonPhone': deliveryPersonPhone,
      };
}

class OrderTimelineModel {
  final String status;
  final String timestamp;
  final String message;
  final bool isCompleted;

  OrderTimelineModel({
    required this.status,
    required this.timestamp,
    required this.message,
    required this.isCompleted,
  });

  factory OrderTimelineModel.fromJson(Map<String, dynamic> json) {
    return OrderTimelineModel(
      status: json['status'] as String? ?? '',
      timestamp: json['timestamp'] as String? ?? '',
      message: json['message'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'timestamp': timestamp,
        'message': message,
        'isCompleted': isCompleted,
      };
}

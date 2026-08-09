class OrderModel {
  final String id;
  final String status; // pending, confirmed, preparing, ready, delivered, cancelled
  final double total;
  final String cafeName;
  final String cafeImage;
  final List<Map<String, dynamic>> items;
  final String deliveryAddress;
  final String createdAt;
  final String? deliveredAt;

  OrderModel({
    required this.id,
    required this.status,
    required this.total,
    required this.cafeName,
    required this.cafeImage,
    required this.items,
    required this.deliveryAddress,
    required this.createdAt,
    this.deliveredAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      cafeName: json['cafeName'] as String? ?? '',
      cafeImage: json['cafeImage'] as String? ?? '',
      items: List<Map<String, dynamic>>.from(json['items'] as List<dynamic>? ?? []),
      deliveryAddress: json['deliveryAddress'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      deliveredAt: json['deliveredAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'status': status,
    'total': total,
    'cafeName': cafeName,
    'cafeImage': cafeImage,
    'items': items,
    'deliveryAddress': deliveryAddress,
    'createdAt': createdAt,
    'deliveredAt': deliveredAt,
  };
}

class OrderEntity {
  final String id;
  final String status;
  final double total;
  final String cafeName;
  final String cafeImage;
  final List<Map<String, dynamic>> items;
  final String deliveryAddress;
  final String createdAt;
  final String? deliveredAt;

  OrderEntity({
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          status == other.status &&
          total == other.total &&
          cafeName == other.cafeName &&
          cafeImage == other.cafeImage &&
          items == other.items &&
          deliveryAddress == other.deliveryAddress &&
          createdAt == other.createdAt &&
          deliveredAt == other.deliveredAt;

  @override
  int get hashCode =>
      id.hashCode ^
      status.hashCode ^
      total.hashCode ^
      cafeName.hashCode ^
      cafeImage.hashCode ^
      items.hashCode ^
      deliveryAddress.hashCode ^
      createdAt.hashCode ^
      deliveredAt.hashCode;
}

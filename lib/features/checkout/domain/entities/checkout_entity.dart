class AddressEntity {
  final String id;
  final String label;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final double latitude;
  final double longitude;
  final bool isDefault;

  AddressEntity({
    required this.id,
    required this.label,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.latitude,
    required this.longitude,
    required this.isDefault,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddressEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          label == other.label &&
          street == other.street &&
          city == other.city &&
          state == other.state &&
          zipCode == other.zipCode &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          isDefault == other.isDefault;

  @override
  int get hashCode =>
      id.hashCode ^
      label.hashCode ^
      street.hashCode ^
      city.hashCode ^
      state.hashCode ^
      zipCode.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      isDefault.hashCode;
}

class PaymentMethodEntity {
  final String id;
  final String type;
  final String lastDigits;
  final String cardholderName;
  final String expiryDate;
  final bool isDefault;

  PaymentMethodEntity({
    required this.id,
    required this.type,
    required this.lastDigits,
    required this.cardholderName,
    required this.expiryDate,
    required this.isDefault,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentMethodEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type &&
          lastDigits == other.lastDigits &&
          cardholderName == other.cardholderName &&
          expiryDate == other.expiryDate &&
          isDefault == other.isDefault;

  @override
  int get hashCode =>
      id.hashCode ^
      type.hashCode ^
      lastDigits.hashCode ^
      cardholderName.hashCode ^
      expiryDate.hashCode ^
      isDefault.hashCode;
}

class OrderEntity {
  final String id;
  final String status;
  final double total;
  final String deliveryAddress;
  final String paymentMethod;
  final String createdAt;

  OrderEntity({
    required this.id,
    required this.status,
    required this.total,
    required this.deliveryAddress,
    required this.paymentMethod,
    required this.createdAt,
    String? deliveredAt,
    required List<Map<String, dynamic>> items,
    required String cafeImage,
    required String cafeName,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          status == other.status &&
          total == other.total &&
          deliveryAddress == other.deliveryAddress &&
          paymentMethod == other.paymentMethod &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      status.hashCode ^
      total.hashCode ^
      deliveryAddress.hashCode ^
      paymentMethod.hashCode ^
      createdAt.hashCode;
}

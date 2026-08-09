class AddressModel {
  final String id;
  final String label;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final double latitude;
  final double longitude;
  final bool isDefault;

  AddressModel({
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

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] as String? ?? '',
      label: json['label'] as String? ?? '',
      street: json['street'] as String? ?? '',
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      zipCode: json['zipCode'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'street': street,
    'city': city,
    'state': state,
    'zipCode': zipCode,
    'latitude': latitude,
    'longitude': longitude,
    'isDefault': isDefault,
  };
}

class PaymentMethodModel {
  final String id;
  final String type; // card, wallet, upi
  final String lastDigits;
  final String cardholderName;
  final String expiryDate;
  final bool isDefault;

  PaymentMethodModel({
    required this.id,
    required this.type,
    required this.lastDigits,
    required this.cardholderName,
    required this.expiryDate,
    required this.isDefault,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? 'card',
      lastDigits: json['lastDigits'] as String? ?? '',
      cardholderName: json['cardholderName'] as String? ?? '',
      expiryDate: json['expiryDate'] as String? ?? '',
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'lastDigits': lastDigits,
    'cardholderName': cardholderName,
    'expiryDate': expiryDate,
    'isDefault': isDefault,
  };
}

class OrderModel {
  final String id;
  final String status;
  final double total;
  final String deliveryAddress;
  final String paymentMethod;
  final String createdAt;

  OrderModel({
    required this.id,
    required this.status,
    required this.total,
    required this.deliveryAddress,
    required this.paymentMethod,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      deliveryAddress: json['deliveryAddress'] as String? ?? '',
      paymentMethod: json['paymentMethod'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'status': status,
    'total': total,
    'deliveryAddress': deliveryAddress,
    'paymentMethod': paymentMethod,
    'createdAt': createdAt,
  };
}

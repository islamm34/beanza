class WalletModel {
  final double balance;
  final double totalSpent;
  final double totalEarned;
  final String currency;
  final bool isVerified;

  WalletModel({
    required this.balance,
    required this.totalSpent,
    required this.totalEarned,
    required this.currency,
    required this.isVerified,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      totalSpent: (json['totalSpent'] as num?)?.toDouble() ?? 0.0,
      totalEarned: (json['totalEarned'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'USD',
      isVerified: json['isVerified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'balance': balance,
    'totalSpent': totalSpent,
    'totalEarned': totalEarned,
    'currency': currency,
    'isVerified': isVerified,
  };
}

class TransactionModel {
  final String id;
  final String type; // credit, debit
  final double amount;
  final String description;
  final String timestamp;
  final String status;
  final String? cafeId;
  final String? orderid;

  TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.timestamp,
    required this.status,
    this.cafeId,
    this.orderid,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? 'debit',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String? ?? '',
      timestamp: json['timestamp'] as String? ?? '',
      status: json['status'] as String? ?? 'completed',
      cafeId: json['cafeId'] as String?,
      orderid: json['orderId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'amount': amount,
    'description': description,
    'timestamp': timestamp,
    'status': status,
    'cafeId': cafeId,
    'orderId': orderid,
  };
}

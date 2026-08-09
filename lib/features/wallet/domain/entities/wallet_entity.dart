class WalletEntity {
  final double balance;
  final double totalSpent;
  final double totalEarned;
  final String currency;
  final bool isVerified;

  WalletEntity({
    required this.balance,
    required this.totalSpent,
    required this.totalEarned,
    required this.currency,
    required this.isVerified,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletEntity &&
          runtimeType == other.runtimeType &&
          balance == other.balance &&
          totalSpent == other.totalSpent &&
          totalEarned == other.totalEarned &&
          currency == other.currency &&
          isVerified == other.isVerified;

  @override
  int get hashCode =>
      balance.hashCode ^
      totalSpent.hashCode ^
      totalEarned.hashCode ^
      currency.hashCode ^
      isVerified.hashCode;
}

class TransactionEntity {
  final String id;
  final String type;
  final double amount;
  final String description;
  final String timestamp;
  final String status;
  final String? cafeId;
  final String? orderId;

  TransactionEntity({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.timestamp,
    required this.status,
    this.cafeId,
    this.orderId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type &&
          amount == other.amount &&
          description == other.description &&
          timestamp == other.timestamp &&
          status == other.status &&
          cafeId == other.cafeId &&
          orderId == other.orderId;

  @override
  int get hashCode =>
      id.hashCode ^
      type.hashCode ^
      amount.hashCode ^
      description.hashCode ^
      timestamp.hashCode ^
      status.hashCode ^
      cafeId.hashCode ^
      orderId.hashCode;
}

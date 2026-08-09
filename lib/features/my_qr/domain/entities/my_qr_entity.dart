class MyQrEntity {
  final String userId;
  final String qrCode;
  final String qrUrl;
  final String membershipId;
  final String createdAt;
  final String expiresAt;

  MyQrEntity({
    required this.userId,
    required this.qrCode,
    required this.qrUrl,
    required this.membershipId,
    required this.createdAt,
    required this.expiresAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyQrEntity &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          qrCode == other.qrCode &&
          qrUrl == other.qrUrl &&
          membershipId == other.membershipId &&
          createdAt == other.createdAt &&
          expiresAt == other.expiresAt;

  @override
  int get hashCode =>
      userId.hashCode ^
      qrCode.hashCode ^
      qrUrl.hashCode ^
      membershipId.hashCode ^
      createdAt.hashCode ^
      expiresAt.hashCode;
}

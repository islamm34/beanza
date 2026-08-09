class MyQrModel {
  final String userId;
  final String qrCode;
  final String qrUrl;
  final String membershipId;
  final String createdAt;
  final String expiresAt;

  MyQrModel({
    required this.userId,
    required this.qrCode,
    required this.qrUrl,
    required this.membershipId,
    required this.createdAt,
    required this.expiresAt,
  });

  factory MyQrModel.fromJson(Map<String, dynamic> json) {
    return MyQrModel(
      userId: json['userId'] as String? ?? '',
      qrCode: json['qrCode'] as String? ?? '',
      qrUrl: json['qrUrl'] as String? ?? '',
      membershipId: json['membershipId'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      expiresAt: json['expiresAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'qrCode': qrCode,
    'qrUrl': qrUrl,
    'membershipId': membershipId,
    'createdAt': createdAt,
    'expiresAt': expiresAt,
  };
}

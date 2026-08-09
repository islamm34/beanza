class LoyaltyPointsModel {
  final int totalPoints;
  final int usedPoints;
  final int availablePoints;
  final String membershipTier;
  final int pointsToNextTier;
  final double multiplier;

  LoyaltyPointsModel({
    required this.totalPoints,
    required this.usedPoints,
    required this.availablePoints,
    required this.membershipTier,
    required this.pointsToNextTier,
    required this.multiplier,
  });

  factory LoyaltyPointsModel.fromJson(Map<String, dynamic> json) {
    return LoyaltyPointsModel(
      totalPoints: json['totalPoints'] as int? ?? 0,
      usedPoints: json['usedPoints'] as int? ?? 0,
      availablePoints: json['availablePoints'] as int? ?? 0,
      membershipTier: json['membershipTier'] as String? ?? 'Bronze',
      pointsToNextTier: json['pointsToNextTier'] as int? ?? 0,
      multiplier: (json['multiplier'] as num?)?.toDouble() ?? 1.0,
    );
  }

  Map<String, dynamic> toJson() => {
    'totalPoints': totalPoints,
    'usedPoints': usedPoints,
    'availablePoints': availablePoints,
    'membershipTier': membershipTier,
    'pointsToNextTier': pointsToNextTier,
    'multiplier': multiplier,
  };
}

class RewardModel {
  final String id;
  final String title;
  final String description;
  final int pointsRequired;
  final String imageUrl;
  final String type; // discount, free_item, bonus_points
  final String value;
  final bool isAvailable;

  RewardModel({
    required this.id,
    required this.title,
    required this.description,
    required this.pointsRequired,
    required this.imageUrl,
    required this.type,
    required this.value,
    required this.isAvailable,
  });

  factory RewardModel.fromJson(Map<String, dynamic> json) {
    return RewardModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      pointsRequired: json['pointsRequired'] as int? ?? 0,
      imageUrl: json['imageUrl'] as String? ?? '',
      type: json['type'] as String? ?? 'discount',
      value: json['value'] as String? ?? '',
      isAvailable: json['isAvailable'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'pointsRequired': pointsRequired,
    'imageUrl': imageUrl,
    'type': type,
    'value': value,
    'isAvailable': isAvailable,
  };
}

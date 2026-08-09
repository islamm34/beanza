class LoyaltyPointsEntity {
  final int totalPoints;
  final int usedPoints;
  final int availablePoints;
  final String membershipTier;
  final int pointsToNextTier;
  final double multiplier;

  LoyaltyPointsEntity({
    required this.totalPoints,
    required this.usedPoints,
    required this.availablePoints,
    required this.membershipTier,
    required this.pointsToNextTier,
    required this.multiplier,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoyaltyPointsEntity &&
          runtimeType == other.runtimeType &&
          totalPoints == other.totalPoints &&
          usedPoints == other.usedPoints &&
          availablePoints == other.availablePoints &&
          membershipTier == other.membershipTier &&
          pointsToNextTier == other.pointsToNextTier &&
          multiplier == other.multiplier;

  @override
  int get hashCode =>
      totalPoints.hashCode ^
      usedPoints.hashCode ^
      availablePoints.hashCode ^
      membershipTier.hashCode ^
      pointsToNextTier.hashCode ^
      multiplier.hashCode;
}

class RewardEntity {
  final String id;
  final String title;
  final String description;
  final int pointsRequired;
  final String imageUrl;
  final String type;
  final String value;
  final bool isAvailable;

  RewardEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.pointsRequired,
    required this.imageUrl,
    required this.type,
    required this.value,
    required this.isAvailable,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RewardEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          pointsRequired == other.pointsRequired &&
          imageUrl == other.imageUrl &&
          type == other.type &&
          value == other.value &&
          isAvailable == other.isAvailable;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      pointsRequired.hashCode ^
      imageUrl.hashCode ^
      type.hashCode ^
      value.hashCode ^
      isAvailable.hashCode;
}

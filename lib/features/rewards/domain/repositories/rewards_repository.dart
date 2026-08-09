import '../entities/rewards_entity.dart';

abstract class RewardsRepository {
  Future<LoyaltyPointsEntity> getLoyaltyPoints();
  Future<List<RewardEntity>> getAvailableRewards();
  Future<RewardEntity> redeemReward(String rewardId);
}

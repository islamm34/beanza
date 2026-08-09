abstract class RewardsRemoteDataSource {
  /// Gets user loyalty points
  Future<Map<String, dynamic>> getLoyaltyPoints();

  /// Gets reward tiers
  Future<List<Map<String, dynamic>>> getRewardTiers();

  /// Gets available rewards
  Future<List<Map<String, dynamic>>> getAvailableRewards();

  /// Redeems a reward
  Future<Map<String, dynamic>> redeemReward(String rewardId);

  /// Gets rewards history
  Future<List<Map<String, dynamic>>> getRewardsHistory();
}

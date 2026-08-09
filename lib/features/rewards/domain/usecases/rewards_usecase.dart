import '../entities/rewards_entity.dart';
import '../repositories/rewards_repository.dart';

class GetLoyaltyPointsUsecase {
  final RewardsRepository repository;

  GetLoyaltyPointsUsecase({required this.repository});

  Future<LoyaltyPointsEntity> call() async {
    return await repository.getLoyaltyPoints();
  }
}

class GetAvailableRewardsUsecase {
  final RewardsRepository repository;

  GetAvailableRewardsUsecase({required this.repository});

  Future<List<RewardEntity>> call() async {
    return await repository.getAvailableRewards();
  }
}

class RedeemRewardUsecase {
  final RewardsRepository repository;

  RedeemRewardUsecase({required this.repository});

  Future<RewardEntity> call(String rewardId) async {
    return await repository.redeemReward(rewardId);
  }
}

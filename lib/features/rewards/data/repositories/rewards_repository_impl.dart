import '../../domain/entities/rewards_entity.dart';
import '../../domain/repositories/rewards_repository.dart';
import '../datasources/rewards_remote_data_source.dart';

class RewardsRepositoryImpl implements RewardsRepository {
  final RewardsRemoteDataSource remoteDataSource;

  RewardsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<LoyaltyPointsEntity> getLoyaltyPoints() async {
    try {
      final data = await remoteDataSource.getLoyaltyPoints();
      return LoyaltyPointsEntity(
        totalPoints: data['totalPoints'] as int? ?? 0,
        usedPoints: data['usedPoints'] as int? ?? 0,
        availablePoints: data['availablePoints'] as int? ?? 0,
        membershipTier: data['membershipTier'] as String? ?? 'Bronze',
        pointsToNextTier: data['pointsToNextTier'] as int? ?? 0,
        multiplier: (data['multiplier'] as num?)?.toDouble() ?? 1.0,
      );
    } catch (e) {
      throw Exception('Failed to get loyalty points: $e');
    }
  }

  @override
  Future<List<RewardEntity>> getAvailableRewards() async {
    try {
      final rewards = await remoteDataSource.getAvailableRewards();
      return rewards
          .map(
            (reward) => RewardEntity(
              id: reward['id'] as String? ?? '',
              title: reward['title'] as String? ?? '',
              description: reward['description'] as String? ?? '',
              pointsRequired: reward['pointsRequired'] as int? ?? 0,
              imageUrl: reward['imageUrl'] as String? ?? '',
              type: reward['type'] as String? ?? 'discount',
              value: reward['value'] as String? ?? '',
              isAvailable: reward['isAvailable'] as bool? ?? true,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get available rewards: $e');
    }
  }

  @override
  Future<RewardEntity> redeemReward(String rewardId) async {
    try {
      final result = await remoteDataSource.redeemReward(rewardId);
      return RewardEntity(
        id: result['id'] as String? ?? '',
        title: result['title'] as String? ?? '',
        description: result['description'] as String? ?? '',
        pointsRequired: result['pointsRequired'] as int? ?? 0,
        imageUrl: result['imageUrl'] as String? ?? '',
        type: result['type'] as String? ?? 'discount',
        value: result['value'] as String? ?? '',
        isAvailable: result['isAvailable'] as bool? ?? true,
      );
    } catch (e) {
      throw Exception('Failed to redeem reward: $e');
    }
  }
}

import '../../domain/entities/onboarding_entity.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../datasources/onboarding_remote_data_source.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingRemoteDataSource remoteDataSource;

  OnboardingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<OnboardingEntity>> getOnboardingScreens() async {
    try {
      final screens = await remoteDataSource.getOnboardingScreens();
      return screens
          .map(
            (screen) => OnboardingEntity(
              id: screen['id'] as int? ?? 0,
              title: screen['title'] as String? ?? '',
              description: screen['description'] as String? ?? '',
              imageUrl: screen['imageUrl'] as String? ?? '',
              color: screen['color'] as String? ?? '#000000',
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get onboarding screens: $e');
    }
  }

  @override
  Future<void> completeOnboarding() async {
    try {
      await remoteDataSource.completeOnboarding();
    } catch (e) {
      throw Exception('Failed to complete onboarding: $e');
    }
  }
}

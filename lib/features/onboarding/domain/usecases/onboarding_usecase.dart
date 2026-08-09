import '../entities/onboarding_entity.dart';
import '../repositories/onboarding_repository.dart';

class GetOnboardingScreensUsecase {
  final OnboardingRepository repository;

  GetOnboardingScreensUsecase({required this.repository});

  Future<List<OnboardingEntity>> call() async {
    return await repository.getOnboardingScreens();
  }
}

class CompleteOnboardingUsecase {
  final OnboardingRepository repository;

  CompleteOnboardingUsecase({required this.repository});

  Future<void> call() async {
    return await repository.completeOnboarding();
  }
}

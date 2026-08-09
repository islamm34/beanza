abstract class OnboardingRemoteDataSource {
  /// Gets onboarding screens data
  Future<List<Map<String, dynamic>>> getOnboardingScreens();

  /// Marks onboarding as completed
  Future<void> completeOnboarding();
}

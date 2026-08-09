abstract class SplashRemoteDataSource {
  /// Gets the app configuration on splash
  Future<void> getAppConfig();

  /// Checks if user is logged in
  Future<bool> isUserLoggedIn();
}

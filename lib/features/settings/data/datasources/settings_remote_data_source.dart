abstract class SettingsRemoteDataSource {
  /// Gets app settings
  Future<Map<String, dynamic>> getSettings();

  /// Updates app settings
  Future<void> updateSettings(Map<String, dynamic> settings);

  /// Gets about info
  Future<Map<String, dynamic>> getAboutInfo();

  /// Logs out user
  Future<void> logout();

  /// Deletes account
  Future<void> deleteAccount();
}

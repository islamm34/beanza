abstract class ProfileRemoteDataSource {
  /// Gets user profile
  Future<Map<String, dynamic>> getProfile();

  /// Updates user profile
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data);

  /// Uploads profile photo
  Future<String> uploadProfilePhoto(String imagePath);

  /// Changes password
  Future<void> changePassword(String oldPassword, String newPassword);
}

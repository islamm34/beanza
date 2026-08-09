import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<UserProfileEntity> getProfile();
  Future<UserProfileEntity> updateProfile(Map<String, dynamic> data);
  Future<void> changePassword(String oldPassword, String newPassword);
}

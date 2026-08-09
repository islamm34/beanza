import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserProfileEntity> getProfile() async {
    try {
      final data = await remoteDataSource.getProfile();
      return UserProfileEntity(
        id: data['id'] as String? ?? '',
        email: data['email'] as String? ?? '',
        fullName: data['fullName'] as String? ?? '',
        phoneNumber: data['phoneNumber'] as String?,
        profileImage: data['profileImage'] as String?,
        dateOfBirth: data['dateOfBirth'] as String?,
        address: data['address'] as String?,
        memberSince: data['memberSince'] as String? ?? '',
        emailVerified: data['emailVerified'] as bool? ?? false,
        phoneVerified: data['phoneVerified'] as bool? ?? false,
      );
    } catch (e) {
      throw Exception('Failed to get profile: $e');
    }
  }

  @override
  Future<UserProfileEntity> updateProfile(Map<String, dynamic> data) async {
    try {
      final result = await remoteDataSource.updateProfile(data);
      return UserProfileEntity(
        id: result['id'] as String? ?? '',
        email: result['email'] as String? ?? '',
        fullName: result['fullName'] as String? ?? '',
        phoneNumber: result['phoneNumber'] as String?,
        profileImage: result['profileImage'] as String?,
        dateOfBirth: result['dateOfBirth'] as String?,
        address: result['address'] as String?,
        memberSince: result['memberSince'] as String? ?? '',
        emailVerified: result['emailVerified'] as bool? ?? false,
        phoneVerified: result['phoneVerified'] as bool? ?? false,
      );
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  @override
  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      await remoteDataSource.changePassword(oldPassword, newPassword);
    } catch (e) {
      throw Exception('Failed to change password: $e');
    }
  }
}

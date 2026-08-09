import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class GetProfileUsecase {
  final ProfileRepository repository;

  GetProfileUsecase({required this.repository});

  Future<UserProfileEntity> call() async {
    return await repository.getProfile();
  }
}

class UpdateProfileUsecase {
  final ProfileRepository repository;

  UpdateProfileUsecase({required this.repository});

  Future<UserProfileEntity> call(Map<String, dynamic> data) async {
    return await repository.updateProfile(data);
  }
}

class ChangePasswordUsecase {
  final ProfileRepository repository;

  ChangePasswordUsecase({required this.repository});

  Future<void> call(String oldPassword, String newPassword) async {
    return await repository.changePassword(oldPassword, newPassword);
  }
}

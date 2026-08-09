import '../entities/settings_entity.dart';
import '../repositories/settings_repository.dart';

class GetSettingsUsecase {
  final SettingsRepository repository;

  GetSettingsUsecase({required this.repository});

  Future<SettingsEntity> call() async {
    return await repository.getSettings();
  }
}

class UpdateSettingsUsecase {
  final SettingsRepository repository;

  UpdateSettingsUsecase({required this.repository});

  Future<void> call(Map<String, dynamic> settings) async {
    return await repository.updateSettings(settings);
  }
}

class LogoutUsecase {
  final SettingsRepository repository;

  LogoutUsecase({required this.repository});

  Future<void> call() async {
    return await repository.logout();
  }
}

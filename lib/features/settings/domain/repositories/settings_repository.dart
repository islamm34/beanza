import '../entities/settings_entity.dart';

abstract class SettingsRepository {
  Future<SettingsEntity> getSettings();
  Future<void> updateSettings(Map<String, dynamic> settings);
  Future<void> logout();
}

import '../../domain/entities/settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_remote_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteDataSource remoteDataSource;

  SettingsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<SettingsEntity> getSettings() async {
    try {
      final data = await remoteDataSource.getSettings();
      return SettingsEntity(
        notificationsEnabled: data['notificationsEnabled'] as bool? ?? true,
        pushNotifications: data['pushNotifications'] as bool? ?? true,
        emailNotifications: data['emailNotifications'] as bool? ?? false,
        themeMode: data['themeMode'] as String? ?? 'auto',
        language: data['language'] as String? ?? 'en',
        locationServices: data['locationServices'] as bool? ?? true,
        privacyLevel: data['privacyLevel'] as String? ?? 'public',
      );
    } catch (e) {
      throw Exception('Failed to get settings: $e');
    }
  }

  @override
  Future<void> updateSettings(Map<String, dynamic> settings) async {
    try {
      await remoteDataSource.updateSettings(settings);
    } catch (e) {
      throw Exception('Failed to update settings: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await remoteDataSource.logout();
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }
}

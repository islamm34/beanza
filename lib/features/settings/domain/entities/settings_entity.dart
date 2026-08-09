class SettingsEntity {
  final bool notificationsEnabled;
  final bool pushNotifications;
  final bool emailNotifications;
  final String themeMode;
  final String language;
  final bool locationServices;
  final String privacyLevel;

  SettingsEntity({
    required this.notificationsEnabled,
    required this.pushNotifications,
    required this.emailNotifications,
    required this.themeMode,
    required this.language,
    required this.locationServices,
    required this.privacyLevel,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsEntity &&
          runtimeType == other.runtimeType &&
          notificationsEnabled == other.notificationsEnabled &&
          pushNotifications == other.pushNotifications &&
          emailNotifications == other.emailNotifications &&
          themeMode == other.themeMode &&
          language == other.language &&
          locationServices == other.locationServices &&
          privacyLevel == other.privacyLevel;

  @override
  int get hashCode =>
      notificationsEnabled.hashCode ^
      pushNotifications.hashCode ^
      emailNotifications.hashCode ^
      themeMode.hashCode ^
      language.hashCode ^
      locationServices.hashCode ^
      privacyLevel.hashCode;
}

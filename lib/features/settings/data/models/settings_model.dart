class SettingsModel {
  final bool notificationsEnabled;
  final bool pushNotifications;
  final bool emailNotifications;
  final String themeMode; // light, dark, auto
  final String language;
  final bool locationServices;
  final String privacyLevel;

  SettingsModel({
    required this.notificationsEnabled,
    required this.pushNotifications,
    required this.emailNotifications,
    required this.themeMode,
    required this.language,
    required this.locationServices,
    required this.privacyLevel,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      pushNotifications: json['pushNotifications'] as bool? ?? true,
      emailNotifications: json['emailNotifications'] as bool? ?? false,
      themeMode: json['themeMode'] as String? ?? 'auto',
      language: json['language'] as String? ?? 'en',
      locationServices: json['locationServices'] as bool? ?? true,
      privacyLevel: json['privacyLevel'] as String? ?? 'public',
    );
  }

  Map<String, dynamic> toJson() => {
        'notificationsEnabled': notificationsEnabled,
        'pushNotifications': pushNotifications,
        'emailNotifications': emailNotifications,
        'themeMode': themeMode,
        'language': language,
        'locationServices': locationServices,
        'privacyLevel': privacyLevel,
      };
}

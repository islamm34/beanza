class SplashModel {
  final bool isLoggedIn;
  final String appVersion;
  final bool isFirstLaunch;

  SplashModel({
    required this.isLoggedIn,
    required this.appVersion,
    required this.isFirstLaunch,
  });

  factory SplashModel.fromJson(Map<String, dynamic> json) {
    return SplashModel(
      isLoggedIn: json['isLoggedIn'] as bool? ?? false,
      appVersion: json['appVersion'] as String? ?? '1.0.0',
      isFirstLaunch: json['isFirstLaunch'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'isLoggedIn': isLoggedIn,
    'appVersion': appVersion,
    'isFirstLaunch': isFirstLaunch,
  };
}

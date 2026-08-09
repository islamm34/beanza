class SplashEntity {
  final bool isLoggedIn;
  final String appVersion;
  final bool isFirstLaunch;

  SplashEntity({
    required this.isLoggedIn,
    required this.appVersion,
    required this.isFirstLaunch,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SplashEntity &&
          runtimeType == other.runtimeType &&
          isLoggedIn == other.isLoggedIn &&
          appVersion == other.appVersion &&
          isFirstLaunch == other.isFirstLaunch;

  @override
  int get hashCode => isLoggedIn.hashCode ^ appVersion.hashCode ^ isFirstLaunch.hashCode;
}

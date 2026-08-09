class AppConstants {
  // App name
  static const String appName = 'Caffeine Live';
  static const String appVersion = '1.0.0';

  // API
  static const String baseUrl = 'https://api.caffeinelive.com';
  static const String apiVersion = '/v1';

  // Authentication
  static const int passwordMinLength = 8;
  static const int otpLength = 6;
  static const int otpResendDelaySeconds = 60;

  // Cart
  static const int maxCartItems = 100;
  static const int maxProductQuantity = 10;

  // Scan
  static const int scanSuccessAnimationDuration = 500; // milliseconds
  static const int scanFrameAnimationDuration = 2000; // milliseconds

  // Timeout
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Rating
  static const double minRating = 1.0;
  static const double maxRating = 5.0;

  // Distance
  static const double nearbyDistanceKm = 5.0;

  // Pagination
  static const int pageSize = 20;
  static const int initialPageNumber = 1;

  // Reward
  static const int pointsPerCoffee = 10;
  static const int pointsPerTransaction = 5;

  // Dark mode
  static const bool defaultDarkMode = false;
}

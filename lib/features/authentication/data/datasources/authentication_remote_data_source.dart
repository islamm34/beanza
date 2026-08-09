abstract class AuthenticationRemoteDataSource {
  /// Login with email and password
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  });

  /// Register a new user
  Future<Map<String, dynamic>> signup({
    required String email,
    required String password,
    required String fullName,
  });

  /// Logout user
  Future<void> logout();

  /// Verify email
  Future<void> verifyEmail(String email, String otp);
}

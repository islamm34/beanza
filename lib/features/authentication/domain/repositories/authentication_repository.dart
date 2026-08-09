import '../entities/authentication_entity.dart';

abstract class AuthenticationRepository {
  Future<AuthenticationEntity> login({
    required String email,
    required String password,
  });

  Future<AuthenticationEntity> signup({
    required String email,
    required String password,
    required String fullName,
  });

  Future<void> logout();

  Future<void> verifyEmail(String email, String otp);
}

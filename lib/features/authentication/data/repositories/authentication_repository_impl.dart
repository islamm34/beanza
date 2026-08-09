import '../../domain/entities/authentication_entity.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../datasources/authentication_remote_data_source.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationRemoteDataSource remoteDataSource;

  AuthenticationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AuthenticationEntity> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await remoteDataSource.login(
        email: email,
        password: password,
      );

      return AuthenticationEntity(
        id: response['id'] as String? ?? '',
        email: response['email'] as String? ?? '',
        fullName: response['fullName'] as String? ?? '',
        phoneNumber: response['phoneNumber'] as String?,
        profileImage: response['profileImage'] as String?,
        accessToken: response['accessToken'] as String? ?? '',
        refreshToken: response['refreshToken'] as String? ?? '',
      );
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<AuthenticationEntity> signup({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final response = await remoteDataSource.signup(
        email: email,
        password: password,
        fullName: fullName,
      );

      return AuthenticationEntity(
        id: response['id'] as String? ?? '',
        email: response['email'] as String? ?? '',
        fullName: response['fullName'] as String? ?? '',
        phoneNumber: response['phoneNumber'] as String?,
        profileImage: response['profileImage'] as String?,
        accessToken: response['accessToken'] as String? ?? '',
        refreshToken: response['refreshToken'] as String? ?? '',
      );
    } catch (e) {
      throw Exception('Signup failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await remoteDataSource.logout();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  @override
  Future<void> verifyEmail(String email, String otp) async {
    try {
      await remoteDataSource.verifyEmail(email, otp);
    } catch (e) {
      throw Exception('Email verification failed: $e');
    }
  }
}

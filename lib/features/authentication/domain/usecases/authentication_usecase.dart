import '../entities/authentication_entity.dart';
import '../repositories/authentication_repository.dart';

class LoginUsecase {
  final AuthenticationRepository repository;

  LoginUsecase({required this.repository});

  Future<AuthenticationEntity> call({
    required String email,
    required String password,
  }) async {
    return await repository.login(email: email, password: password);
  }
}

class SignupUsecase {
  final AuthenticationRepository repository;

  SignupUsecase({required this.repository});

  Future<AuthenticationEntity> call({
    required String email,
    required String password,
    required String fullName,
  }) async {
    return await repository.signup(
      email: email,
      password: password,
      fullName: fullName,
    );
  }
}

class LogoutUsecase {
  final AuthenticationRepository repository;

  LogoutUsecase({required this.repository});

  Future<void> call() async {
    return await repository.logout();
  }
}

class VerifyEmailUsecase {
  final AuthenticationRepository repository;

  VerifyEmailUsecase({required this.repository});

  Future<void> call(String email, String otp) async {
    return await repository.verifyEmail(email, otp);
  }
}

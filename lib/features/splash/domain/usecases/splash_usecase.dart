import '../entities/splash_entity.dart';
import '../repositories/splash_repository.dart';

class SplashUsecase {
  final SplashRepository repository;

  SplashUsecase({required this.repository});

  Future<SplashEntity> call() async {
    return await repository.getSplashData();
  }
}

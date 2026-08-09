import '../../domain/entities/splash_entity.dart';
import '../../domain/repositories/splash_repository.dart';
import '../datasources/splash_remote_data_source.dart';

class SplashRepositoryImpl implements SplashRepository {
  final SplashRemoteDataSource remoteDataSource;

  SplashRepositoryImpl({required this.remoteDataSource});

  @override
  Future<SplashEntity> getSplashData() async {
    try {
      await remoteDataSource.getAppConfig();
      final isLoggedIn = await remoteDataSource.isUserLoggedIn();
      
      return SplashEntity(
        isLoggedIn: isLoggedIn,
        appVersion: '1.0.0',
        isFirstLaunch: false,
      );
    } catch (e) {
      throw Exception('Failed to get splash data: $e');
    }
  }
}

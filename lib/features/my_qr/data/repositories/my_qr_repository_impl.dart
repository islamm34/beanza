import '../../domain/entities/my_qr_entity.dart';
import '../../domain/repositories/my_qr_repository.dart';
import '../datasources/my_qr_remote_data_source.dart';

class MyQrRepositoryImpl implements MyQrRepository {
  final MyQrRemoteDataSource remoteDataSource;

  MyQrRepositoryImpl({required this.remoteDataSource});

  @override
  Future<MyQrEntity> getQrCode() async {
    try {
      final data = await remoteDataSource.getQrCode();
      return MyQrEntity(
        userId: data['userId'] as String? ?? '',
        qrCode: data['qrCode'] as String? ?? '',
        qrUrl: data['qrUrl'] as String? ?? '',
        membershipId: data['membershipId'] as String? ?? '',
        createdAt: data['createdAt'] as String? ?? '',
        expiresAt: data['expiresAt'] as String? ?? '',
      );
    } catch (e) {
      throw Exception('Failed to get QR code: $e');
    }
  }

  @override
  Future<MyQrEntity> regenerateQrCode() async {
    try {
      final data = await remoteDataSource.regenerateQrCode();
      return MyQrEntity(
        userId: data['userId'] as String? ?? '',
        qrCode: data['qrCode'] as String? ?? '',
        qrUrl: data['qrUrl'] as String? ?? '',
        membershipId: data['membershipId'] as String? ?? '',
        createdAt: data['createdAt'] as String? ?? '',
        expiresAt: data['expiresAt'] as String? ?? '',
      );
    } catch (e) {
      throw Exception('Failed to regenerate QR code: $e');
    }
  }
}

import '../entities/my_qr_entity.dart';

abstract class MyQrRepository {
  Future<MyQrEntity> getQrCode();
  Future<MyQrEntity> regenerateQrCode();
}

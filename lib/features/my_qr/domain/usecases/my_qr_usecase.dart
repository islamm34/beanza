import '../entities/my_qr_entity.dart';
import '../repositories/my_qr_repository.dart';

class GetQrCodeUsecase {
  final MyQrRepository repository;

  GetQrCodeUsecase({required this.repository});

  Future<MyQrEntity> call() async {
    return await repository.getQrCode();
  }
}

class RegenerateQrCodeUsecase {
  final MyQrRepository repository;

  RegenerateQrCodeUsecase({required this.repository});

  Future<MyQrEntity> call() async {
    return await repository.regenerateQrCode();
  }
}

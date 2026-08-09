import '../entities/scanner_entity.dart';
import '../repositories/scanner_repository.dart';

class DecodeScanUsecase {
  final ScannerRepository repository;

  DecodeScanUsecase({required this.repository});

  Future<ScanResultEntity> call(String scanData) async {
    return await repository.decodeScan(scanData);
  }
}

class ProcessScanUsecase {
  final ScannerRepository repository;

  ProcessScanUsecase({required this.repository});

  Future<ScanResultEntity> call(String scanData, String type) async {
    return await repository.processScan(scanData, type);
  }
}

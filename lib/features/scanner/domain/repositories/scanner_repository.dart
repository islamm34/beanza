import '../entities/scanner_entity.dart';

abstract class ScannerRepository {
  Future<ScanResultEntity> decodeScan(String scanData);
  Future<ScanResultEntity> processScan(String scanData, String type);
}

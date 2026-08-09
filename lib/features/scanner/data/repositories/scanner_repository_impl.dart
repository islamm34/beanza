import '../../domain/entities/scan_result_entity.dart';
import '../../domain/repositories/scanner_repository.dart';
import '../datasources/scanner_remote_data_source.dart';

class ScannerRepositoryImpl implements ScannerRepository {
  final ScannerRemoteDataSource remoteDataSource;

  ScannerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ScanResultEntity> decodeScan(String scanData) async {
    try {
      final result = await remoteDataSource.decodeScan(scanData);
      final format = result['type'] as String? ?? 'QR_CODE';
      return ScanResultEntity(
        rawValue: scanData,
        barcodeFormat: format,
        scanType: ScanResultEntity.classifyType(format, scanData),
        timestamp: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to decode scan: $e');
    }
  }

  @override
  Future<ScanResultEntity> processScan(String scanData, String type) async {
    try {
      final result = await remoteDataSource.processScan(scanData, type);
      final format = result['type'] as String? ?? type;
      return ScanResultEntity(
        rawValue: scanData,
        barcodeFormat: format,
        scanType: ScanResultEntity.classifyType(format, scanData),
        timestamp: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to process scan: $e');
    }
  }
}

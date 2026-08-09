import '../../domain/entities/scan_history_entity.dart';
import '../../domain/repositories/scan_history_repository.dart';
import '../datasources/scan_history_remote_data_source.dart';

class ScanHistoryRepositoryImpl implements ScanHistoryRepository {
  final ScanHistoryRemoteDataSource remoteDataSource;

  ScanHistoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ScanHistoryEntity>> getScanHistory() async {
    try {
      final history = await remoteDataSource.getScanHistory();
      return history
          .map(
            (scan) => ScanHistoryEntity(
              id: scan['id'] as String? ?? '',
              type: scan['type'] as String? ?? 'qr',
              scannedData: scan['scannedData'] as String? ?? '',
              resultType: scan['resultType'] as String?,
              resultTitle: scan['resultTitle'] as String?,
              timestamp: scan['timestamp'] as String? ?? '',
              wasSuccessful: scan['wasSuccessful'] as bool? ?? true,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get scan history: $e');
    }
  }

  @override
  Future<void> deleteScanRecord(String scanId) async {
    try {
      await remoteDataSource.deleteScanRecord(scanId);
    } catch (e) {
      throw Exception('Failed to delete scan record: $e');
    }
  }

  @override
  Future<void> clearScanHistory() async {
    try {
      await remoteDataSource.clearScanHistory();
    } catch (e) {
      throw Exception('Failed to clear scan history: $e');
    }
  }
}

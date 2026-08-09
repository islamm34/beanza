import '../entities/scan_history_entity.dart';

abstract class ScanHistoryRepository {
  Future<List<ScanHistoryEntity>> getScanHistory();
  Future<void> deleteScanRecord(String scanId);
  Future<void> clearScanHistory();
}

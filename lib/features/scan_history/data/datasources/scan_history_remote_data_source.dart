abstract class ScanHistoryRemoteDataSource {
  /// Gets scan history
  Future<List<Map<String, dynamic>>> getScanHistory();

  /// Gets scan details
  Future<Map<String, dynamic>> getScanDetails(String scanId);

  /// Deletes scan record
  Future<void> deleteScanRecord(String scanId);

  /// Clears scan history
  Future<void> clearScanHistory();
}

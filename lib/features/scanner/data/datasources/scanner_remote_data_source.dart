abstract class ScannerRemoteDataSource {
  /// Decodes QR/barcode data
  Future<Map<String, dynamic>> decodeScan(String scanData);

  /// Processes scanned code
  Future<Map<String, dynamic>> processScan(String scanData, String type);

  /// Gets scan history
  Future<List<Map<String, dynamic>>> getScanHistory();
}

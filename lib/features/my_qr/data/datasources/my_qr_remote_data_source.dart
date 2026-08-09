abstract class MyQrRemoteDataSource {
  /// Gets user's QR code
  Future<Map<String, dynamic>> getQrCode();

  /// Regenerates QR code
  Future<Map<String, dynamic>> regenerateQrCode();
}

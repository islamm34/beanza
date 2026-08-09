class ScanRecord {
  final String id;
  final String rawValue;
  final String format;
  final String type; // qr, barcode, unknown
  final DateTime timestamp;

  ScanRecord({
    required this.id,
    required this.rawValue,
    required this.format,
    required this.type,
    required this.timestamp,
  });
}

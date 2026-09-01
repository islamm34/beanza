enum ScanType { qr, barcode, unknown }

class ScanResultEntity {
  final String rawValue;
  final String barcodeFormat;
  final ScanType scanType;
  final DateTime timestamp;

  ScanResultEntity({
    required this.rawValue,
    required this.barcodeFormat,
    required this.scanType,
    required this.timestamp,
  });

  static ScanType classifyType(String format, String value) {
    if (value.trim().isEmpty) return ScanType.unknown;
    final lowerFormat = format.toLowerCase();
    if (lowerFormat.contains('qr') ||
        lowerFormat.contains('aztec') ||
        lowerFormat.contains('matrix')) {
      return ScanType.qr;
    } else if (lowerFormat.contains('code') ||
        lowerFormat.contains('ean') ||
        lowerFormat.contains('upc') ||
        lowerFormat.contains('itf') ||
        lowerFormat.contains('pdf417') ||
        lowerFormat.contains('barcode')) {
      return ScanType.barcode;
    }
    return ScanType.unknown;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScanResultEntity &&
          runtimeType == other.runtimeType &&
          rawValue == other.rawValue &&
          barcodeFormat == other.barcodeFormat &&
          scanType == other.scanType &&
          timestamp == other.timestamp;

  @override
  int get hashCode =>
      rawValue.hashCode ^
      barcodeFormat.hashCode ^
      scanType.hashCode ^
      timestamp.hashCode;
}
